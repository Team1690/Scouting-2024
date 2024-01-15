# Scouting-Template
A template for future scouting apps.

###Requirements
- A functional and ready Hasura database containing the new season-specific variables.
#

####Before we begin
Before splitting to the seprate views, make sure you change the table names in main.dart if needed, as this would affect multiple screens and widgets in the app.

####Input View & Technical Match
Usually this would be the first screen you want to build.
- match_model.dart - In here, you should define the season specific TechnicalMatch variables (see TODOS in file)
- input_view.dart - now that you have everything defined, you should be able to design your input view. 
Remember to create the mutations according to the current seasons variables and needs.
Note that some widgets should/shouldnt be displayed when specific conditions are met, such as if the robot is not on the field.
#
###Pit View
- pit_vars.dart: add season specific variables (from the database) to PitVars where needed (see TODOs)
- pit_view.dart: add necessary widgets for the new variables and update mutations (add to the existing ones)
#
### Coach View
- coach_view.dart: start by adding your season specific data that you wish to display to the CoachViewLightTeam class. Then, add the tables and variables needed to claculate said data, to the query. Then, in the fetch function, initialize your data and return the resulting CoachViewLightTeams. Then all you have to do is to display your data in the UI. note the suggested validation statement before presenting the data (see TODOs), as we dont want to display data for teams with no matches, as their data is arbitrary.
#
###Coach Team Info & Team Info
These screens are mostly intertwined with each other, and the same goes for their respective features, fetch, classes, etc... So, working in order doesnt really work here. try starting with the fetch and working your way out with each tab/widget at a time.
NOTE: inside the fetch_team_info.dart file, there should be validators in place to make sure data isnt pulled from the returning json (from the query) if there arent any matches, so there wouldnt be a null exception if, data is being pulled from a null instead of a list (see nullValidator in the 2023 scouting app)
- fetch_team_info.dart: start by updating the query with your freshly added variables and tables (in the database). you can also choose to update each part of the query as you go, for example, add the pit variables when you start working on the pit card. your call. But we recommend adding everything beforehand to avoid trouble later.
#####QuickData
- team_info_classes.dart: decide and add the needed season-specific data to the QuickData class.
- fetch_team_info.dart: initialize (via the query data) the new variables that were added to the QuickData class.
- quick_data.dart: add the new data to the UI (see TODOs), if they do not fit in any of the categories, feel free to add more.
#####Pit
- team_info_classes.dart: decide and add the needed season-specific variables (that you added to the pit table) to PitData.
- fetch_team_info.dart: initialize the new variables that were added to the query and add them to the PitData Class via the members you added in the previous step.
- pit_scouting_card.dart: add the new variables to the UI display.
- edit_pit.dart: Just add the new season specific pit variables alongside the existing ones.
#####GameCharts
- team_info_classes.dart: decide which gamecharts you would like to present, then add them (in LineChartData form) to the Team class.
- fetch_team_info.dart: initialize the data required for the linecharts and the LineChartData themselves according to the ones you created in the previous step. (you might want to look at the previous year's file for help if you are struggling with the creation of the LineChartDatas)
- game_chart_card.dart: add the Linecharts themselves, using the LineChartData from Team (which is passed into the screen). they should be inside a CarouselWithIndicator that is commented int the file. note that there should be a validator in place to avpid showing the charts if there are less than 2 games (also see comments)
#####Coach Team Info 
- coach_team_info.dart: add the new variables accordingly to your changes to PitData, QuickData, AutoData, SpecifcData, and Gamecharts, and add their respective UIs (mainly just follow the TODOs)
#
#
### Status Screen
- fetch_status.dart: replace table names in the query and fetch (see TODOs), and add the season specific variables that will be used in order to calculate the points of each team in a match, to the query, initialize and calculate them and pass it on to StatusMatch instead of the current set value (follow TODOs along the file). 
- edit_technical_match.dart: here you would need to mainly deal with database stuff. you would need to add a query for the selected (singular) match, and the parsing of said match into a Match class which will be returned by the parserFn (see TODOs)
#
#
### PickList & AutoPickList
-pick_list_widget: add season specific variables that you wish to display such as avg points, balance scores, etc. make sure to include amountOfMatches and faultMessages which should always be useful.
- fetch_picklist.dart: add season specific variables and tables to the query. usually this would include some Pit variables, faults (from within the pit table), most of the technical match variables (in order to sum up gamepieces), climbs, match statuses, etc.
then, initialize and calculate the variables you wish to display (such as avg points, balance scores, etc) and return them in a PickListTeam format.
- pick_list_widget: display your data. (see TODOs. there are premade ones in a comment).
- auto_picklist_widget.dart: add the filters (if not already added in PickListTeam) and factors, and display the season specific variables. If this turns out exactly the same as your PickList widget, you should make a base widget that they both use to avoid code dupe.
- value_sliders.dart: rename and add filters and factors (see TODOs)
- auto_picklist_screen.dart: add and rename the newly added factors and filters (see TODOs), then, actually initialize and calculate said factors and filters so that they actually update the selection (once again, see TODOs as there are some examples commented below them) 


