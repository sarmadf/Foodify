# ECS189E/project-f19-recipeapp 

## Our App 
Foodify is an app that gives you recipes that uses ingredients in your pantry. Users can search recipes 
by entering ingredients or using our built in ML Image recognizer, view past recipes and more. 
In order to run the App please use davisrecipeapp@gmail.com as your developer ID. Password: Davisecs189
### Trello Link
Our final team trello board can be found [here](https://trello.com/b/egF1VdsP/ecs-189e-project).

### App Description
Our App contains seven main views: the Home Screen, the IngedientsAdd view, the Camera view, the RecipesList view, the Recipe view, the Pantry View, and the PantryIngredientsAdd View.

#### Home Screen
The Home Screen is a guiding post of sorts containing buttons and segues to Pantry and IngredientsAdd and some links to recently viewed recipes. The segues and UI were done by Stephen.<br>
[Link](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/RecipeView.swift])

#### Ingredients Add View
This view contains a search bar and a table view that the search results are displayed in. The UI and the behaviour of the Search Results Table were done by Aaron. Ashwin handled the API calls needed to get the data to fill in the search results table and pass in selected ingredients to the next view: the Recipes List View. The UI was provided by Aaron and the Api functionality was provided by Ashwin.

Next to the Search bar is a camera button that pulls up the Camera View on top of the Ingredients Add View. <br>
[Link](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/IngredientsAdd.swift)

#### Camera View
The Camera View contains a view that activates the user's phone camera. Using a combination of CoreML and Google Vision API, the app is able to recognize and display recognized items to the label on the top. The app alternates between CoreML's text recognition and Google Vision's image recognition depending on which gives more confident classifications. The Add button on the bottom appends the currently recognized item to the Ingredients Add view's Search Result Table. Once the user has added as many ingredients as they wish, the user can click the Done button to leave. The ingredients added will be verified once the user returns to the previous view controller. The Camera View and APIs were implemented by Sarmad.<br>
[Link](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/CameraViewController.swift)

#### RecipeList View
After the user searches inputs the ingredients they want to use, the RecipeList View displays a list of recipe search results using the Spoonacular API. If the user clicks on a particular recipe, it will be displayed in more detail in the Recipe View. The UI was done by Aaron and Stephen. The API was implemented by Ashwin.<br>
[Link](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/RecipesViewController.swift)

#### Recipe View
This view displays detailed information concerning a particular recipe. The UI and api calls were done by Ashwin. <br>
[Link](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/RecipeView.swift)

#### Pantry View
This view contains ingredients that the user has stored. The Storage class(adapted from Professor King's version) was used to store the user's ingredients on their device. If the user clicks the Select button, they have the option to select ingredients to input to a recipe search or select ingredients to delete. Clicking add segues to the PantryAdd View. This view was done by Aaron.<br>
[Link](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/PantryViewController.swift)

#### PantryAdd View
This view allows the user to add new recipes to their pantry, with all the functionality of IngredientsAdd. This view was done by Aaron. <br>
[Link](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/PantryIngredientsAdd.swift)

### The Team 
![AshwinPicture](https://user-images.githubusercontent.com/20465283/68833227-d00afa80-0667-11ea-89fa-b5f6e9f20d25.jpg)
    
Ashwin Muralidharan
ashwinmd

<p>
  <img src="https://raw.githubusercontent.com/aakim-git/PDFs/master/Forward.jpg" width="350" title="hover text">
</p>

Aaron Kim
aakim-git

![StephenPicture](https://avatars1.githubusercontent.com/u/24659025?s=460&v=4)

Stephen Ednave
StephenEdnave

Sarmad Farooq
sarmadf

  <img src= "https://user-images.githubusercontent.com/35645151/68896050-7e9e5200-06df-11ea-87a6-458363780de6.jpg" width="350" title="hover text">
