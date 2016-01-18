![logo](http://i.imgur.com/q574Wb8.png)

Points Of Interest is a plugin for [Cuberite](cuberite.org) which allows you to create "waypoints" using signs. Players can search for them and claim them by right-clicking the sign, which encourages exploration.

### Commands
| Command | Description | 
| ------- | ----------- | 
|/poi update | Updates the POI database (used when manually editing the database).| 
|/poi claimed {player} | Shows a list of claimed POIs.| 
|/poi ammount | Shows a total number of all created POIs.| 
|/poi list | Shows a list of all created POIs.| 
|/poi remove [id] | Removes a POI with a specific id.| 
|/poi purge [id] {player} | Removes all claims of a specific POI id. (Optionally only deletes claims of a specific player)| 
|/poi purgeplayer [player] | Removes all claims of a specific player on all POIs.| 

### Permissions
| Command or Hook | Permission | 
| ------- | ----------- | 
|All Commands and Hooks  | poi.*| 
|Creating a POI | poi.create| 
|Claiming a POI | poi.claim| 
|/poi update | poi.update| 
|/poi claimed | poi.claimed| 
|/poi ammount | poi.ammount| 
|/poi list | poi.list| 
|/poi remove | poi.remove| 
|/poi purge | poi.purge| 
|/poi purgeplayer | poi.purgeplayer| 

### How to create a Point Of Interest
Place a sign anywhere in the world. The first line has to contain *[poi]* or *[POI]*. Second line has to be the name of the new POI. After creating the sign, its lines will be automatically updated. If you see a confirmation message appear in chat, the POI has been created.

![poi](http://i.imgur.com/6DacNin.jpg)
