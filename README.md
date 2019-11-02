# Rx-VIPER-ToDo

This repository is an example of using Rx to implement the VIPER architecture.

As far as I know VIPER was first described in [Architecting iOS Apps with VIPER](https://www.objc.io/issues/13-architecture/viper/) back in June 2014. I decided to revisit this pattern and see how it can be adapted to live in our new, more functional and reactive world.

I will re-implement the sample that came with the article above, but I also want to take this time to discuss a bit about the process of developing a program with the idea of documenting some of the non-code processes involved in creating an application.

## User Stories

The first step in developing an application is to decide what the application is supposed to do. It doesn’t have to be a complete list, but it should include all the functionality that immediately comes to mind. This functionality is specified by a number of User Stories; they consist of a number of entities and they allow a number of different types of user to perform a number of actions with those entities.

Every application will have different entities and different types of user, but most applications are of a CRUD nature. CRUD is an acronym for Create Read Update Delete which are the actions that can be performed on entities. Every entity does not have to have every action, but every action should be considered. Sometimes only certain types of users will be able to perform certain actions on certain entities.

For the purposes of this application, we only have one user type and one entity type. The former we will call _User_ and the latter will be _ToDo_.  Now let's consider the actions. Since this is just a sample app we will only allow the create and read actions. Here are our user stories.

* As a User, I can create a ToDo.
* As a User, I can read all ToDos due this week and next.

> A side note about naming things. In order to foster communication in a team it’s important to be consistent about what things should be called. Naming is hard, but once you pick a name, stick with it. If you absolutely must change it, change it everywhere, including in code.

## Wireframe

The next step is to draw out a [wireframe](https://en.wikipedia.org/wiki/Website_wireframe). This is often done for websites, but it’s also [important for mobile apps](https://www.upwork.com/hiring/for-clients/importance-of-wireframing-mobile-apps/). Also during this phase, the processes involved in all the user stories will be augmented with the steps the user needs to go through in order to complete the user story.

These user story steps will start on a particular screen and will detail the actions the user must take in order to complete the story. (i.e., "from screen X, tap button Y, enter Z information, and so on until completion.")

This phase will produce a list of screens, the functionality (inputs & outputs) available in each screen, connections between screens, as well as a path for each user story from above.

It’s important to remember that this is not a waterfall process. It is quite likely that new user stories will be discovered during this phase along with new entities and users. As they are discovered, a decision will have to be made as to whether these new stories and screens must be in the current version of the application, or can be set aside for a future version. If it is determined that they must be included in the current version, then update the wireframe and user story list to include them, and make sure that all stake-holders have buy-in regarding the added scope. These additions will affect costs and deadlines and it’s unprofessional to ignore that fact or try to hide it.

In our case, we are expecting two screens. We will call them the _List_ and _Add_ screens. In the process of drawing them out, we have identified another user story as well as steps for each. The new story acknowledges the fact that creating a ToDo is a multistep process from the user's perspective and gives the user the ability to abort the create action.

```
(-) As a User, I can create a ToDo.
    From the List screen:
      Tap the add button to display the Add screen.
      Enter a title and date of a ToDo (both are required.)
      Tap save button to save ToDo and dismiss ToDo screen.

(-) As a User, I can cancel the create ToDo action.
    From the Add screen:
      Tap cancel button to dismiss Add screen without saving.

(-) As a User, I can read all ToDos due this week and next.
    From the List screen:
      ToDos should be in date order.
      ToDos should be grouped in the following categories: Today, Tomorrow, Later This Week, and Next Week.
```

## Order of Work

Now it’s time to decide in which order the user stories will be developed. During this process it’s important to take into account any dependencies between stories. If you have stories that deal with sub-entities of some entity then they need to come after the stories about the entities. Each story starts on a particular screen so it is sometimes helpful to group stories by the screen they start on. Lastly, it’s generally easier to develop stories in CRUD order for a particular entity.

The process of developing a user story isn’t just about writing code, each screen also needs a detail-design and decisions need to be made about application wide fonts and colors. All of this can generally be done in parallel; however, it’s best if the detail design of a screen comes before development so that code doesn’t have to be revisited.
And again because this is so important: Even during this process, new user stories, entities and users could be discovered (especially in regard to error paths through stories,) and maybe new screens will be required. If the stake-holders decide they must be in the current version of the application then update the previous deliverables.

For this sample app, I have already ordered the user stories in the list above according to my preference.

## Development

We have a solid understanding now of what the user can do and we know what order we are going to develop those features in. We also have detail designs for the screens needed (at least for the first user story) and a list of fonts and colors that will be used throughout the app. Now it's time to start development.

> Before talking about how to adapt VIPER to Rx, I want to clear up a misconception about the architecture. Some people assume that there must be a VIPER (View, Interactor, Presenter, Wireframe) stack for every screen, but that is not at all true. Sometimes a single screen might be involved in multiple user stories at the same time and so will have several interactors. Sometimes a screen might be used for several different stories and have multiple Wireframes and Presenters associated with it. Lastly, sometimes multiple screens might be involved in a single user story and then one Wireframe will display several screens.

### Story 1, Step 1: Tap the add button to display the _Add_ screen.

In this commit, I am implementing the first step of the first user story, "Tap the add button to display the _Add_ screen." Of course a lot has to be done for this simple step because in order to tap that add button, we need an application. Since the user story starts on the _List_ screen, we need to create that as well, but only in so far as to give it an add button. Notice I haven't fleshed out the rest of the screen. I went ahead and laid out the entire _Add_ screen since I know I need it for the rest of this story. Also, since this is the step that displays the _Add_ screen and the detail-design calls for a special presentation animation I did that here.

With the original conception of VIPER, each component was a class with several functions. In Rx things are a bit different. Here each component tends to be a single function. So I have the files named based on the component they represent, but each file only contains a single exposed function and possibly some private helper functions.

When the app starts up, the flow is as follows:

1. The ListWireframe is given control.
2. Since the storyboard has already displayed the _List_ screen, the wireframe only needs to install the presenter into the view controller's buildOutput function.
3. The ListViewController eventually loads, creates its Input object and then passes that input to the buildOutput function.

When the user taps the add button, the flow is as follows:

1. The addItem emits a next event to the list presenter.
2. The list presenter maps that to an add ListAction and emits that to the wireframe.
3. The list wireframe catches the add action and calls displayAdd which is in the AddWireframe.swift file.
4. The add wireframe instantiates the add view controller and presents it.

### Story 1, Step 2: Enter a title and date of a ToDo (both are required.)

Much of the functionality of this commit was actually added in the last commit since I laid out the _Add_ screen. However, to help ensure the stipulation that both title and date are required for saving, this is a good time to make sure the save button is only enabled if there is valid input. This is our first real bit of logic so I went ahead and added tests. Tests aren't often added to sample code so I thought it would be a nice touch.

You will see that the logic is all in the presenters so that's what is tested. In a properly constructed VIPER system, all of the logic will be in the presenters and interactors. I expect to have a test case for each user story.

### Story 1, Step 3: Tap save button to save ToDo and dismiss ToDo screen.

For this step, we created our first interactor. We have also discovered a path not mentioned in the user stories. We need to outline what happens if the save fails. As mentioned, we **update the user story** with this newly discovered information.

```
(-) As a User, I can create a ToDo.
    From the List screen:
      Tap the add button to display the Add screen.
      Enter a title and date of a ToDo (both are required.)
      Tap save button to save ToDo and dismiss ToDo screen.
    Error: If the save fails, instead of dismissing the ToDo screen, an Alert screen displays explaining the error.
```

One of the defining features of VIPER is that _only_ Interactors work with Entities and the DataStore, the Wireframe injects the DataStore into the Interactor, and the Presenter knows nothing about the DataStore _or_ the Entities. 

You will notice that the presenter doesn't create a Todo object, instead it just passes enough information to the Interactor for _it_ to create the Todo object which then passes it to the DataStore. Then the DataStore converts the Todo object into a form that is savable and saves it.

It's interesting to note that up to this point, our code has been indistinguishable from an MVVM-C architecture (other than the names of things.) VIPER adds an extra level of indirection between the interactor (view model) and the entities/data store. In MVVM-C, the view model works directly with them both. Personally, I'm not sure if this extra level of indirection is useful. Even in an application this small, I'm left wondering where I should change the date of the object to the `startOfDay`? Should it be done in the presenter or in the interactor?

### Story 2, Step 1: Tap cancel button to dismiss Add screen without saving.

Since the screen and button for this story have already been laid out, it's just a matter of hooking them up. We add the cancel button to the UI's input, and then bind it directly to the wireframe's Observable.

### Story 3: Read Todos.

An important thing to notice at this point is all the different ways a "Todo" is represented in the system, even in something as simple as this example program. 

* There's the way the DataStore represents todos internally (in our case, as a plist structure and if we had used CoreData then as `NSManagedObject`s),
* There's the way todos are represented internally by the interactors (and externally by the DataStore) as `Todo` structs.
* There's the way todos are represented internally by presenters (and externally by interactors.) The list presenter uses `UpcomingItem`.
* Lastly, theres the way todos are represented internally by view controllers (and externally by presenters.) The list view controller uses `UpcomingDisplaySection/UpcomingDisplayItem`

Again we are struck with the difference in complexity between MVVM-C and VIPER; in the former there would only be three different representations of a todo rather than four. Maybe in a larger project it would make more sense; presumably we would find re-use opportunities that wouldn't otherwise exist?

For this story, you will see that most of the changes/additions are dedicated to morphing the data in the stored plist into data the table view can understand over the four stages mentioned above. I also had to modify the AddWireframe so it could notify its parent about successful updates and pass that into the List presenter so it will know when to re-get the list of items.
