# Flutter Todo App
 A flutter todo app using flutter_bloc with features including network status check and localization support with the capability to update translations from server.

## How to run the app?
### Pre-requisites
- ```Node.js``` to run the json server for storing todo list and translations.

### Setup json server
- Install ```json-server``` from npm.
- Create db.json file in any directory.
- Run the following command: ```json-server --host <YOUR_IPv4_ADDRESS> <PATH_TO_DB.JSON> --watch```

### Run the app
- Update the ```apiBase``` value in [constants.dart](https://github.com/kushan-developer/bloc_todo_app/blob/main/lib/constants/constants.dart)
- Run the ```flutter run``` command in the root dir of the project.
