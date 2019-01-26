# Text MARVEL Combat Area

This Rails app works like this for the user:

1. The user (or two users battling against each other) will provide 2 character names to do battle in the arena
2. The user will provide a SEED number between 1-9
3. The API call to the Marvel universe will retrieve the bio for each character and parse the “description” field
4. The WORD in each description corresponding to the provided SEED is identified
5. The winner of the battle is the character whose WORD has the most characters EXCEPT if either character has a MAGIC WORD “Gamma” or “Radioactive” they automatically Win
6. Present the winning character to the user


Things I need to remember about the Marvel API:
1. Add this in a partial layout for each view with the data from the API: "Data provided by Marvel. © 2014 Marvel"
2. If I use significant data I need to link the entity back to its URL

Other:
1. Handle any errors or edge cases and display the message in a user friendly manner
2. Provide clear instructions on how to retrieve and run your code

### How to start

clone this repo
run bundler
start the rails server
you will need to insert your own Marvel API key in the controller code, which you can get at https://developer.marvel.com/account, just replace ENV[MARVEL_PUBLIC_KEY] and ENV[MARVEL_PRIVATE_KEY] with yours.

### Ruby version

Ruby 2.5.3
