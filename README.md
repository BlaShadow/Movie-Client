# Movie-Client

A basic integration from an ios app with *The Movie Database* (TMDb) [TMDb](https://www.themoviedb.org/documentation/api) api, this project has implemented 3 fearure:

- List of movies from discover section
- Show movie details
- Make a search for any movie using a text criteria

# Architecture

The app architecture it's kind of a mix of some pattern tech I al ready know and with the experience I've been modeling and feel conforable working with.

Project
- **DataAccess**
    - **LocalStorage**: This is where I put all loca storage iteration, any percistance of local data 
    - **Remote**: Remote call to web service
        - **Domain**: Entity used in remote 
    - **ResponseHandlers**: All response been handle here like parsing data, creating some objects, saving into cache, etc.
    - **Domain**
    **DataFacadeAccess**: Central point where all controller consume all desire data 
- **Core Extensions**: Extensions for clases la Color, Date, those basic models. 
- **Delegate**: All my delegate live here, using some sub-folders to meke it more clear
- **View**: My custom views, customs cell and so on
- **Controller**: Controllers :)

# Setup

This app is using pod for managing packages, so:

```sh
pod instal
```

You need to setup this project with your own **Movie DB Api Key**

![Schema](https://github.com/BlaShadow/Movie-Client/blob/development/screenshots/schema.png)

# Screenshot app

![Screenshot1](https://github.com/BlaShadow/Movie-Client/blob/development/screenshots/Simulator%20Screen%20Shot%20-%20iPhone%206%20-%202018-07-19%20at%2002.37.28.png)
![Screenshot2](https://github.com/BlaShadow/Movie-Client/blob/development/screenshots/Simulator%20Screen%20Shot%20-%20iPhone%206%20-%202018-07-19%20at%2002.37.31.png)
![Screenshot3](https://github.com/BlaShadow/Movie-Client/blob/development/screenshots/Simulator%20Screen%20Shot%20-%20iPhone%206%20-%202018-07-19%20at%2002.37.42.png)