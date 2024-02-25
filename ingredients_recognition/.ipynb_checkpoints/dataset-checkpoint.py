import torch
import cv2
import matplotlib.image as mpimg
import numpy as np
import torchvision.transforms as transforms
from torch.utils.data import Dataset
import functions as f
import json



class ImageDataset(Dataset):
    def __init__(self, csv, train, test): # (self, csv, Bool, Bool)
        self.csv = csv
        self.train = train
        self.test = test
        self.all_image_names = self.csv[:]['Image_Name'] # String here correspond to the csv column name
        self.all_ingredients = np.array([json.loads(lst_str) for lst_str in self.csv[:]['Encoded_ingredient']]) # labels
        self.train_ratio = int(0.85*len(self.csv))
        self.valid_ratio = len(self.csv) - self.train_ratio
        
        # Define transformations for images according to the train/test mode. Split image names and ingredients according to ratio.
        # training
        if self.train == True:
            print(f'Number of training images: {self.train_ratio}')
            self.image_names = list(self.all_image_names[:self.train_ratio])
            self.ingredients = list(self.all_ingredients[:self.train_ratio])
            # Apply transformations
            self.transform = transforms.Compose([
                transforms.ToPILImage(),
                transforms.Resize((400,400)),
                transforms.RandomHorizontalFlip(p=0.5),
                transforms.RandomRotation(degrees=45),
                transforms.ToTensor(),
            ])
        
        # validation
        elif self.test == False and self.train == False:
            self.image_names = list(self.all_image_names[-self.train_ratio:-10])
            self.ingredients = list(self.all_ingredients[-self.train_ratio:-10])

            self.transform = transforms.Compose([
                transforms.ToPILImage(),
                transforms.Resize((400,400)),
                transforms.ToTensor(),
            ])
            
        # inference
        elif self.test == True and self.train == False:
            self.image_names = list(self.all_image_names[-10:])
            self.ingredients = list(self.all_ingredients[-10:])

            self.transform = transforms.Compose([
                transforms.ToPILImage(),
                transforms.ToTensor(),
            ])

            
    def __len__(self):
        return len(self.image_names)
    
    
    def __getitem__(self, index):
        image_name = self.image_names[index]
        image = mpimg.imread(f'/Users/mushr/Programming/AI_Projects/Digital_Health/food_dataset/food_img/{image_name}.jpg')
        image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) # Changing the color
        if image.dtype == 'float32':
            image = (image * 255).astype(np.uint8)
        image = self.transform(image)
        targets = self.ingredients[index]

        return {
            'Image':torch.tensor(image, dtype=torch.float32),
            'Image_Name': image_name,
            'Encoded_ingredient':torch.tensor(targets, dtype=torch.float32)
        }

                               
        
 