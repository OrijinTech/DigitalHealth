import torch.nn as nn
import torch.nn.functional as F
from torchvision import models as models
import functions as f



# https://debuggercafe.com/multi-label-image-classification-with-pytorch-and-deep-learning/


def model(pretrained, requires_grad):
    model = models.resnet50(progress=True, pretrained=pretrained)
    num_ingredients = int(len(f.get_ingredients()))
    
    # Freeze hidden layers 
    if requires_grad == False:
        print(f'Finetuning the model, requires_grad set to {requires_grad}')
        for param in model.parameters():
            param.requires_grad = False
    # Train hidden layers
    elif requires_grad == True:
        print(f'Training the hidden layers, requires_grad set to {requires_grad}')
        for param in model.parameters():
            param.requires_grad = True
            
    # output layer
    model.fc = nn.Linear(model.fc.in_features, num_ingredients)
    
    return model









