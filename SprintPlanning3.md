# Sprint Planning Meeting 3
### App Description
Foodify is an app that gives you recipes that uses ingredients in your pantry. Users can search recipes 
by entering ingredients or using our built in ML Image recognizer, save recipes and more. 

### Trello Link
The team trello board can be found [here](https://trello.com/b/egF1VdsP/ecs-189e-project).

# Meeting Summary
Discussed changes to UI and flow between ingredient search and recipe search. How to integrate vision into app. The IngredientsSearch view controller will now contain a camera button that will pull up the camera. Once the user takes a picture, the classified ingredient will show up in the IngredientsSearch view controller. There will also be an option to input ingredients via a text field, in case the classification failed and the user wishes to change their input.
# Individual Reports
## Ashwin
### Accomplishments
Completed Api Model. Can perform a recipe search using a comma-separated list of ingredients. Created a struct to represent data associated with a single recipe.
 
### Planned
Integrate Api with existing UI
Complete RecipeSearch view controller

## Sarmad
### Accomplishments
 Wrote python scripts and set up cloud account to test potential vision capability. looking around documentation and potential libraries led to google firebase mlkit as a better solution and iOS coreML as potential backup. Read through documentation and usage of text detection image and image tagging API for mlkit. Also looked for potential camera usage library.

### Planned
Work on Google Firebase image recognition
Set up picture taking and tag displaying
(stretch): Set up text recognition if image classification doesn't match the food category
## Stephen
### Accomplishments
Implemented front-end in XCode as specified by the wireframe and the transitions between view controllers.

### Planned
Finish Recipe View


## Aaron
### Accomplishments
Worked on Pantry view

### Planned
Saved Recipes Model
Look into Settings
Storage: Saving Recipes and Storing pantry state

