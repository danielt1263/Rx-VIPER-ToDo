# Rx-VIPER-ToDo

This repository is an example of using Rx to implement the VIPER architecture.

As far as I know VIPER was first described in [Architecting iOS Apps with VIPER on objc.io](https://www.objc.io/issues/13-architecture/viper/) back in June 2014. I decided to revisit this pattern and see how it can be adapted to live in our new, more functional and reactive world.

I will re-implement the sample that came with the article above, but I also want to take this time to discuss a bit about the process of developing a program. With the idea of documenting some of the non-code processes involved in creating an application.

## User Stories

The first step in developing an application is to decide what the application is supposed to do. This doesn't have to be a complete list, but it should include all the functionality that immediatly comes to mind. Most applications are of a CRUD nature; They consist of a number of entities, and they allow the user to perform actions with those entities. The first step then is to identify the major entities in the application and which of the actions (Create Read Update Delete) can be performed on each. Every entity does not have to have every action, but every action should be considered. Sometimes, an application is designed with different users in mind as well. In those cases it is also necessary to consider the entities and actions in light of which users are allowed to perform which actions on which entities.

For the purposes of this application, we only have one user type and one entity type. The former we will call _User_ and the latter will be _ToDo_.  Now let's consider the actions. Since this is just a sample app, we will only allow the create and read actions. Here are our user stories.

* As a User, I can create a ToDo.
* As a User, I can read all ToDos due this week and next.

## Wireframe

The next step is to draw out a [wireframe](https://en.wikipedia.org/wiki/Website_wireframe) this is often done for websites, but it's also [important for mobile apps](https://www.upwork.com/hiring/for-clients/importance-of-wireframing-mobile-apps/). While drawing the wireframe, new functionality (i.e., new user stories) might come to mind and the processes involved in all the user stories will be fleshed out.

> A side note about naming things. In order to foster communication in a team it's important to be consistent about what things should be called. Naming is hard, but once you pick a name, stick with it. In this writeup I am italicising these important terms.

In our case, we are expecting two screens. We will call them the _List_ and _Add_ screens. In the process of drawing them out, we have identified another user story as well as steps for each. The new story acknoldeges the fact that creating a ToDo is a multistep process from the user perspective and give the user the ability to abort the create action.

```
(-) As a User, I can create a ToDo.
    From the List screen:
      Tap the add button to present the Add screen.
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

Now it's time to decide in which order the user stories will be developed. During this process it's importatnt to take into account any dependencies between stories. If you have stories that deal with sub-entities of some entity then they need to come after the stories about the entities. Each story starts on a particular screen so it is often helpful to group stories by the screen they start on. Lastly, it's generally easier to develop stories in CRUD order for a particular entity.

The process of developing a user story isn't just about writing code, each screen also needs a detail-design and decisions need to be made about fonts and colors. All of this can generally be done in parallel; however, it's best if the detail design of a screen comes before development so that code doesn't have to be revisited.

Often during this process, new user stories will be discovered, and maybe new screens will be required. A decision will have to be made as to whether these new stories and screens must be in the current version of the application, or can be set asside for a future version. If it is determined that they must be included in the current version, then **update the wireframe and user story list** to include them! And make sure that all stake-holders have buy-in reguarding the added scope. These additions will affect costs and deadlines and it's unprofessional to ignore that fact or try to hide it.

For this sample app, I have already ordered the user stories in the list above according to my preference.
