# Gymondo_assessment1


1. Clone the project 
2. Checkout main branch
3. Install the pods before building project.

# Project description

# List Screen


This project will show the list of first 20 exercise. If exercise has images then it show up all the images available to particular exercise. In the list user can see the title and Image of exercise.

  •	For Exercise list I am using  https://wger.de/api/v2/exercise/?language=2 
  •	For images I was using https://wger.de/api/v2/exerciseinfo/   as exerciseImages returning 404 error for all the exercises.


# Details Screen

Upon tap on any exercise in the list screen user will navigate to the details page where we are showing title, Images, description and Variations. Variations and images will show only if exercise has those.

  •	User can see the details of the variation on click on variation item.
  •	Here I using calling the https://wger.de/api/v2/exerciseinfo/   api for both details and variation details 

