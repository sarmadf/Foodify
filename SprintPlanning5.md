# Sprint Planning Meeting 5
### App Description
Foodify is an app that gives you recipes that utilizes ingredients in your pantry. Users can search recipes 
by entering ingredients or using our built in ML Image recognizer, save recipes and more. 

### Trello Link
The team trello board can be found [here](https://trello.com/b/egF1VdsP/ecs-189e-project).

# Meeting Summary
Checked in on everyone's progress. Merged our work. Discussed how to finalize the app for Thursday, Demo Day. 

# Individual Reports
## Ashwin
### Accomplishments
- Hooked up API to the Search view and Individual Recipe views. 
- Worked on UI of the Individual Recipe Views

### Planned
- Finalize Search and Individual Recipe view. 

### Issues
- No issues.

### Links
- [RecipesViewController](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/RecipesViewController.swift)
- [RecipeView](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/RecipeView.swift)

## Sarmad
### Accomplishments
- Tested solutions for best live capture API, both MLkit and CoreML. Integrated both API to have both text recoginition
and coreML tagging capabilities

### Planned
- Looking for ways to make ingredient add from camera user fiendly
- Finalize Vision API implementation and finish Camera View controller. 

### Issues
- Apple Vision API seems lackluster. We will have to transition to Google's vision API. 

### Links
- [Example](wwww.google.com)

## Stephen
### Accomplishments
Fixed all merge conflicts between the PantryView and UI branches. Edited segues and view controllers.
Implemented recently viewed recipes container on the home screen.

### Planned
Hook up most recently viewed recipe to Storage and home screen.

### Issues
- No issues.

### Links
- [Home Screen](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/HomeScreen.swift)



## Aaron
### Accomplishments
- Finished Pantry view
- Began Ingredient Search view

### Planned
- Finalize transitions between views 
- Finalize UI and style
- Fix Pantry add ingredients bugs

### Issues
- Waiting for the Search view controller to be finished.

### Links
- [Pantry: View Controller](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/PantryViewController.swift)
- [Pantry: Adding Ingredients](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/PantryIngredientsAdd.swift)
- [IngredientsAdd: Filling in table with search results](https://github.com/ECS189E/project-f19-recipeapp/blob/master/Recipe%20App/Recipe%20App/IngredientsAdd.swift)
