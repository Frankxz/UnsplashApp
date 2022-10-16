# UnsplashApp
**Test app** \
A simple application using the **Unsplash API** to search for photos by keyword. \
On the first tab bar VC  - the search screen displayed random fetched images. 
On the second tab bar VC  - the favorites screen displayed liked and saved in UserDefaults images


# Functionality
## ViewControllers
### PhotosCollectionViewController
<img src="https://sun9-west.userapi.com/sun9-48/s/v1/ig2/Y6ZnmabmTpbnV97DZaGleHjXw-ZAICCYnp452Qrb6-fK47D4qPP3J5GabbAJmYSP7WHjWaPbbYLF4aSRhitg_n52.jpg?size=698x1386&quality=96&type=album" width="225" height="450">
The search screen at the beginning displayed random fetched images.

#### PhotosCollectionView
- During scrolling, if scrolled down to the last element of collectionView,  asynchronously start loading more images
- Custom "waterFall" layout
- Custom apearing alpha animation

#### SearchController
- When text in searchBar begin changing the searchBar, requests are made to search for images by keyword
- Since the API has a limit of 50 requests per hour, created Timer to avoid or minimize unnecessary requests, while user printing

### FavoritesCollectionViewController
<img src="https://sun9-west.userapi.com/sun9-61/s/v1/ig2/AUkx1ke-tqND1EsDilHQ7OTBiiquN5fPmg8CCc0kK7ByzQm7TW_Vf5-iJk0HChcVdLFv74T1hYvdoQDyzccPFw0W.jpg?size=720x1374&quality=96&type=album" width="225" height="450">

- The favorites screen displayed liked and saved in UserDefaults images
- Custom apearing alpha animation


### DetailViewController
<img src="https://sun9-north.userapi.com/sun9-84/s/v1/ig2/X0sQB63rv2hAueRY5Ih5kI25T9ku4jKxLnTLLb042pDhDLZ5Ezos74wtDfcqYAiikE1kNdUV62WWB-jlu4t7KP7B.jpg?size=716x712&quality=96&type=album" width="450" height="450">

Appears after touching on selected cell. Present a large image and detailed information of this image in custom Bottom Sheet

#### InfoView
Represents detail info of Image \

Contains info:
- Author name
- Description
- Location
- Downloads number
- Creation date

Buttons:
- Like button -> save / remove from Favorites List
- Action button -> UIActivityViewController()
- Original size -> PhotoViewController()


### PhotoViewController
<img src="https://sun9-north.userapi.com/sun9-88/s/v1/ig2/9VivDTTps0iWqtl6ZReCHO6mBFgWw98Af6jWKgyZU_-9bscsn8LSaSKjgQE74dI1KnApiSoStRBxuPXlddjup1VO.jpg?size=558x1080&quality=96&type=album" width="225" height="450">

Used to display the best quality image in the correct aspect ratio. Also here is saveBarButtonItem 

## Services

### 1. Network

####    1.1 NetworkService
           Serves to configuring URLS with parameters and REQUESTS for Unsplash API

####    1.2 NetworkManager
           Contains methods to decode JSON and fetching data

### 2. StorageManager
        Serves to work with UserDefaults for saving, fetching, remove favorites photo

### 3. AppUtility
        Serves to lock orientation and prevent screen rotation

# Demonstration
<img src="https://media0.giphy.com/media/zTty9nkHpmbO5fRLkq/giphy.gif?cid=790b76119e855ade9dd7b67ee8db30e96c258250f0a31c44&rid=giphy.gif&ct=g" width="225" height="450">


**Practice with:** \
Unsplash API \
UserDefaults \
UrlSession \
SDWebImage
