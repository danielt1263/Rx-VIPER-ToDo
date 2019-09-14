# Rx-VIPER-ToDo

This repository is an example of using Rx to implement the VIPER architecture.

As far as I know VIPER was first described in [Meet VIPER: Mutual Mobile’s application of Clean Architecture for iOS apps](https://mutualmobile.com/resources/meet-viper-fast-agile-non-lethal-ios-architecture-framework) back in June 2014. I decided to revisit this pattern and see how it can be adapted to live in our new, more functional and reactive world.

I will re-implement the sample that came with the article above, but I also want to take this time to discuss a bit about the process of developing a program with the idea of documenting some of the non-code processes involved in creating an application.

## User Stories

The first step in developing an application is to decide what the application is supposed to do. This doesn't have to be a complete list, but it should include all the functionality that immediatly comes to mind. Most applications are of a CRUD nature; They consist of a number of entities, and they allow the user to perform actions with those entities. The first step then is to identify the major entities in the application and which of the actions (Create Read Update Delete) can be performed on each. Every entity does not have to have every action, but every action should be considered. Sometimes, an application is designed with different users in mind as well. In those cases it is also necessary to consider the entities and actions in light of which users are allowed to perform which actions on which entities.

For the purposes of this application, we only have one user type and one entity type. The former we will call _User_ and the latter will be _ToDo_.  Now let's consider the actions. Since this is just a sample app we will only allow the create and read actions. Here are our user stories.

* As a User, I can create a ToDo.
* As a User, I can read all ToDos due this week and next.

## Wireframe

The next step is to draw out a [wireframe](https://en.wikipedia.org/wiki/Website_wireframe). This is often done for websites, but it's also [important for mobile apps](https://www.upwork.com/hiring/for-clients/importance-of-wireframing-mobile-apps/). While drawing the wireframe, new functionality (i.e., new user stories) might come to mind and the processes involved in all the user stories will be fleshed out.

> A side note about naming things. In order to foster communication in a team it's important to be consistent about what things should be called. Naming is hard, but once you pick a name, stick with it. In this writeup I am italicising these important terms.

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

Now it's time to decide in which order the user stories will be developed. During this process it's important to take into account any dependencies between stories. If you have stories that deal with sub-entities of some entity then they need to come after the stories about the entities. Each story starts on a particular screen so it is often helpful to group stories by the screen they start on. Lastly, it's generally easier to develop stories in CRUD order for a particular entity.

The process of developing a user story isn't just about writing code, each screen also needs a detail-design and decisions need to be made about application wide fonts and colors. All of this can generally be done in parallel; however, it's best if the detail design of a screen comes before development so that code doesn't have to be revisited.

Often during this process, new user stories will be discovered, and maybe new screens will be required. A decision will have to be made as to whether these new stories and screens must be in the current version of the application, or can be set asside for a future version. If it is determined that they must be included in the current version, then **update the wireframe and user story list** to include them! And make sure that all stake-holders have buy-in reguarding the added scope. These additions will affect costs and deadlines and it's unprofessional to ignore that fact or try to hide it.

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
