import torch
from torch import nn
from torch.utils.data import Dataset, DataLoader, random_split
from torchvision import datasets, transforms
import neural_net
import dataset as d

import numpy as np
import os
from sklearn.model_selection import train_test_split
from PIL import Image
from IPython.display import display
import pandas as pd
import matplotlib.pyplot as plt
from tqdm import tqdm

import requests



# ------------------------------------------------------------------------------------- #
#                                MACHINE LEARNING FUNCTIONS                             #
# ------------------------------------------------------------------------------------- #

def train(model,
          train_data,
          valid_data,
          optimizer,
          criterion,
          device,
          epochs,
          batch_size,
          save_model=False,
          plot_losses=False
          ):
    
    # Data Loader
    train_loader = DataLoader(train_data, batch_size, shuffle=True)
    valid_loader = DataLoader(valid_data, batch_size, shuffle=True)
    
    train_loss = []
    valid_loss = []
    
    for epoch in range(epochs):
        print(f'Epoch {epoch+1}/{epochs}')
        train_epoch_loss = train_one_epoch(model, train_loader, optimizer, criterion, train_data, device)
        valid_epoch_loss = validate(model, valid_loader, criterion, valid_data, device)
        train_loss.append(train_epoch_loss)
        valid_loss.append(valid_epoch_loss)
        print(f'Train Loss: {train_epoch_loss:.4f}')
        print(f'Validation Loss: {valid_epoch_loss:.4f}')
        if save_model:
            print(f'Model saved at epoch: {epoch}')
            save_model_per_epoch(model, epochs, criterion, optimizer, train_loss, valid_loss)
        if plot_losses:
            plot_per_epoch(train_loss=train_loss, valid_loss=valid_loss)
    
    return train_loss, valid_loss


def train_one_epoch(model, dataloader, optimizer, criterion, train_data, device):
    print('Training...')
    model.train()
    counter = 0 #number of batches per epoch
    train_running_loss = 0.0
    
    for i, data in tqdm(enumerate(dataloader), total=int(len(train_data)/dataloader.batch_size)):
        counter += 1
        data, target = data['Image'].to(device), data['Encoded_ingredient'].to(device)
        optimizer.zero_grad()
        outputs = model(data)
        outputs = torch.sigmoid(outputs)
        loss = criterion(outputs, target)
        train_running_loss += loss.item()
        loss.backward()
        optimizer.step()
        
    train_loss = train_running_loss/counter
    return train_loss


def validate(model, dataloader, criterion, val_data, device):
    print('Validating...')
    model.eval()
    counter = 0
    val_running_loss = 0.0
    with torch.no_grad():
        for i, data in tqdm(enumerate(dataloader), total=int(len(val_data)/dataloader.batch_size)):
            counter += 1
            data, target = data['Image'].to(device), data['Encoded_ingredient'].to(device)
            outputs = model(data)
            outputs = torch.sigmoid(outputs)
            loss = criterion(outputs, target)
            val_running_loss += loss.item()
            
        val_loss = val_running_loss / counter
        return val_loss
    

def save_model_per_epoch(model, epochs, criterion, optimizer, train_loss, valid_loss):
    # Save model
    torch.save({'epoch': epochs,
                'model_state_dict': model.state_dict(),
                'optimizer_state_dict': optimizer.state_dict(),
                'loss': criterion,
               },'model.pth')

def plot_per_epoch(train_loss, valid_loss):
    # Plot Losses
    plt.figure(figsize=(10,7))
    plt.plot(train_loss, color='red', label='Train Loss')
    plt.plot(valid_loss, color='blue', label='Validation Loss')
    plt.xlabel('Epochs')
    plt.ylabel('Loss')
    plt.legend()
    plt.savefig('loss.png')
    plt.show()


def inference(device, csv): # str, str
    model = neural_net.model(pretrained=False, requires_grad=False).to(device)
    checkpoint = torch.load('model.pth')
    model.load_state_dict(checkpoint['model_state_dict'])
    model.eval()

    train_csv = pd.read_csv(csv)
    list_of_ing = get_ingredients()

    test_data = d.ImageDataset(train_csv, test=True, train=False)
    test_loader = DataLoader(test_data, batch_size=1, shuffle=False)

    for counter, data in enumerate(test_loader):
        image, target = data['Image'].to(device), data['Encoded_ingredient']
        # get all the index positions where value == 1
        target_indices = [i for i in range(len(target[0])) if target[0][i] == 1]

        # get the predictions by passing the image through the model
        threshold = 0.2
        outputs = model(image)
        outputs = torch.sigmoid(outputs)
        outputs = outputs.detach().cpu()
        out_len = outputs[outputs > threshold].size(0)
        sorted_indices = torch.argsort(outputs[0]) # outputs[0] = percentages of each ingredient
        best = sorted_indices[-out_len:]
        string_predicted = ''
        string_actual = ''
        pred_list_str = []
        actual_list_str = []
        for i in range(len(best)):
            string_predicted += f"{list_of_ing[best[i]]}, "
            pred_list_str.append(list_of_ing[best[i]])
        for i in range(len(target_indices)):
            string_actual += f"{list_of_ing[target_indices[i]]}, "
            actual_list_str.append(list_of_ing[target_indices[i]])

        sorted_pred = sorted(best.tolist())
        pred_list_str = sorted(pred_list_str)
        actual_list_str = sorted(actual_list_str)
        total_cal = total_cal_in_recipe(pred_list_str)

        # Output
        image = image.squeeze(0)
        image = image.detach().cpu().numpy()
        image = np.transpose(image, (1, 2, 0))
        plt.imshow(image)
        plt.axis('off')
        plt.title(f'File Name: {data["Image_Name"][0]}')
        plt.show()

        print(f'PREDICTED: {pred_list_str}\nACTUAL: {actual_list_str}')
        print(f'PREDICTED: {sorted_pred} with {len(sorted_pred)} ingredients\nACTUAL: {target_indices} with {len(target_indices)} ingredients')
        print(f'SIMILARITY: {compare_lists(sorted_pred, target_indices)}%')
        print(f'Total Calorie of the Dish: {total_cal} kcal')
        print('-'*120)

        
# ------------------------------------------------------------------------------------- #
#                                   HELPER FUNCTIONS                                    #
# ------------------------------------------------------------------------------------- #

    
def compare_lists(l1, l2):
    set1 = set(l1)
    set2 = set(l2)
    intersection = len(set1.intersection(set2))
    union = len(set1) + len(set2) - intersection
    if union == 0:
        similarity = 0.0
    else:
        similarity = intersection/union
    return similarity * 100


def get_ingredients():
    ingred = open('/Users/mushr/Programming/MachineLearning/food_recognition/ingredients.txt', 'r')
    list_of_ing = ingred.read().splitlines()
    return list_of_ing


# API KEY: arMslUqZXenPVPCxFIFfNuuVSfxS83K3pTiN5cAS
# USDA Website: https://fdc.nal.usda.gov/
def get_calorie(ingredient, print_err=False):
    API_KEY = 'arMslUqZXenPVPCxFIFfNuuVSfxS83K3pTiN5cAS'
    base_url = 'https://api.nal.usda.gov/fdc/v1/foods/search'
    query_data = {'query' : ingredient,
                  'api_key': API_KEY}
    err_msg = 'None'
    kcal = 0
    try:
        found_ingredient = requests.get(base_url, params=query_data)
        if found_ingredient.status_code == 200:
            data = found_ingredient.json()
                    # Extracting relevant information (e.g., calories)
            if data['foods']:
                food = data['foods'][0]
                for nutrient in food['foodNutrients']:
                    if nutrient['nutrientName'] == 'Energy':
                        kcal = nutrient['value']
                err_msg = 'Calories not found for the given food'
            else:
                err_msg = 'No information found for the given food'
        else:
            print('Error: Unable to retrieve data from the API')
    except Exception as e:
        err_msg = f'Error: {str(e)}'

    if print_err:
        print(err_msg)

    return kcal


def total_cal_in_recipe(ingredients): # ingredients = list of str
    total_cal = 0
    for ingred in ingredients:
        total_cal += get_calorie(ingred)
    return total_cal

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    