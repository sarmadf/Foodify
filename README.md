# ECS189E/project-f19-recipeapp 

## Our App 
Foodify is an app that gives you recipes that uses ingredients in your pantry. Users can search recipes 
by entering ingredients or using our built in ML Image recognizer, view past recipes and more. 

### Trello Link
Our final team trello board can be found [here](https://trello.com/b/egF1VdsP/ecs-189e-project).
wireframes for app [here](https://github.com/sarmadf/Foodify/blob/master/wireframes.pdf).

### App Description
Our App contains seven main views: the Home Screen, the IngedientsAdd view, the Camera view, the RecipesList view, the Recipe view, the Pantry View, and the PantryIngredientsAdd View.

#### Home Screen
The Home Screen is a guiding post of sorts containing buttons and segues to Pantry and IngredientsAdd and some links to recently viewed recipes. The segues and UI were done by Stephen.<br>

#### Ingredients Add View
This view contains a search bar and a table view that the search results are displayed in. The UI and the behaviour of the Search Results Table were done by Aaron. Ashwin handled the API calls needed to get the data to fill in the search results table and pass in selected ingredients to the next view: the Recipes List View. The UI was provided by Aaron and the Api functionality was provided by Ashwin.

Next to the Search bar is a camera button that pulls up the Camera View on top of the Ingredients Add View. <br>

#### Camera View
The Camera View contains a view that activates the user's phone camera. Using a combination of CoreML and Google Vision API, the app is able to recognize and display recognized items to the label on the top. The app alternates between CoreML's text recognition and Google Vision's image recognition depending on which gives more confident classifications. The Add button on the bottom appends the currently recognized item to the Ingredients Add view's Search Result Table. Once the user has added as many ingredients as they wish, the user can click the Done button to leave. The ingredients added will be verified once the user returns to the previous view controller. The Camera View and APIs were implemented by Sarmad.<br>

#### RecipeList View
After the user searches inputs the ingredients they want to use, the RecipeList View displays a list of recipe search results using the Spoonacular API. If the user clicks on a particular recipe, it will be displayed in more detail in the Recipe View. The UI was done by Aaron and Stephen. The API was implemented by Ashwin.<br>

#### Recipe View
This view displays detailed information concerning a particular recipe. The UI and api calls were done by Ashwin. <br>

#### Pantry View
This view contains ingredients that the user has stored. The Storage class(adapted from Professor King's version) was used to store the user's ingredients on their device. If the user clicks the Select button, they have the option to select ingredients to input to a recipe search or select ingredients to delete. Clicking add segues to the PantryAdd View. This view was done by Aaron.<br>

#### PantryAdd View
This view allows the user to add new recipes to their pantry, with all the functionality of IngredientsAdd. This view was done by Aaron. <br>

### The Team     
Ashwin Muralidharan
ashwinmd

Aaron Kim
aakim-git

Stephen Ednave
StephenEdnave

Sarmad Farooq
sarmadf
