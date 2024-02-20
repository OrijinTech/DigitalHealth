import torch
from torch import nn
from torch.utils.data import Dataset, DataLoader, random_split
from torchvision import datasets, transforms
import neural_net
import dataset

import numpy as np
import os
from sklearn.model_selection import train_test_split
from PIL import Image
from IPython.display import display
import pandas as pd
import matplotlib.pyplot as plt
from tqdm import tqdm




def get_ingredients():
    ingred = open('/Users/mushr/Programming/MachineLearning/food_recognition/ingredients.txt', 'r')
    list_of_ing = ingred.read().splitlines()
    return list_of_ing


def train(model,
          train_data,
          valid_data,
          optimizer,
          criterion,
          device,
          epochs,
          batch_size,
          save_model=False
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
        save_model(model, epochs, criterion, train_loss, valid_loss)
    
    return train_loss, valid_loss


def train_one_epoch(model, dataloader, optimizer, criterion, train_data, device):
    print('Training...')
    model.train()
    counter = 0 #number of batches per epoch
    train_running_loss = 0.0
    
    for i, data in tqdm(enumerate(dataloader), total=int(len(train_data)/dataloader.batch_size)):
        counter += 1
        data, target = data['Image_Name'].to(device), data['encoded_ingredient'].to(device)
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
            data, target = data['Image_Name'].to(device), data['encoded_ingredient'].to(device)
            outputs = model(data)
            outputs = torch.sigmoid(outputs)
            loss = criterion(outputs, target)
            val_running_loss += loss.item()
            
        val_loss = val_running_loss / counter
        return val_loss
    

def save_model(model, epochs, criterion, train_loss, valid_loss):
    # Save model
    torch.save({'epoch': epochs,
                'model_state_dict': model.state_dict(),
                'optimizer_state_dict': optimizer.state_dict(),
                'loss': criterion,
               },'model.pth')
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

    test_data = dataset.ImageDataset(train_csv, train=False, test=True)
    test_loader = DataLoader(test_data, batch_size=1, shuffle=False)

    for counter, data in enumerate(test_loader):
        image, target = data['Image_Name'].to(device), data['encoded_ingredient']
        # get all the index positions where value == 1
        target_indices = [i for i in range(len(target[0])) if target[0][i] == 1]
        print(target)
        # get the predictions by passing the image through the model
        outputs = model(image)
        outputs = torch.sigmoid(outputs)
        outputs = outputs.detach().cpu()
        sorted_indices = np.argsort(outputs[0])
        best = sorted_indices[-6:]
        string_predicted = ''
        string_actual = ''
        for i in range(len(best)):
            string_predicted += f"{list_of_ing[best[i]]}    "
        for i in range(len(target_indices)):
            string_actual += f"{list_of_ing[target_indices[i]]}    "
        image = image.squeeze(0)
        image = image.detach().cpu().numpy()
        image = np.transpose(image, (1, 2, 0))
        plt.imshow(image)
        plt.axis('off')
        plt.title(f"PREDICTED: {string_predicted}\nACTUAL: {string_actual}")
        plt.show()
        
        
