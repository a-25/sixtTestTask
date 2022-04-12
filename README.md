This application displays cars on map and list. 

# Installation
```sh
git clone [repo url]
cd sixtTestTask/Sixt
pod install
open Sixt.xcworkspace
```

# Stack
- MVC
- Coordinators
- CocoaPods 
- Alamofire /*Simplifies working with network*/
- SnapKit /*Simplifies dealing with AutoLayout*/
- Kingfisher /*Image loading library*/
- ProgressHUD /*Show beatiful loaders*/

# Simplifications
1. I used MVC as the main architecture. In the real project we could possibly use another one (or it will already exist). But for this project it is sufficient and simple.
2. Also I used coordinators (a single one) to structure routing between controllers.
3. For DI I used the most simple way - plain static class. In the real project we could possibly use existing DI library with advanced behavior.
4. Modularization is made through folders (also in a simple way). In the real project we could possibly use separating modules to different targets / frameworks / development pods to make the code more independent. Or, maybe, not a single module but a group of modules in a separate target.
5. Clusterization on MapKit works natively and works well, so I did not implement it by hand.
6. I could write more unit tests, but they would be more complex. So I decided that this number is sufficient to show an example.
7. If the car list is very huge (more than 200 - 300 cars), we should possibly use pagination when loading cars. Or maybe sort them by rating (or any other parameter like distance) and return first 200 - 300 cars. Otherwise the processing will be too slow (network, parsing, map display, memory storage and so on).
8. I didn't implement filters on map / list but in real application they would possibly be useful. I implemented sorting on car list for illustration how could I make filters. 
 
# Other simplifications
Other simplifications are written like comments in the specific code parts.  
