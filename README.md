# time-2-rottnest-island
A shell script that finds the total time and the next available ferry time to Rottnest Island, Perth, WA.

Task:


The data is released as a collection of inter-related textfiles following the Google Transit Feed Specification (GTFS), which is also used by many other public transport companies, worldwide.

Perth has a very good suburban train service. Unfortunately it is not very extensive and, if you need to a reach a destination via train, you often need to first catch a bus (or walk) to a train station. Perth also has a very attractive tourist destination, Rottnest Island. Unfortunately you cannot reach Rottnest Island by train, but you can travel to the last station on the Fremantle Train Line (Stop No: 99352), which is right next to the Rottnest Island B-shed ferry terminal! Perfect.

So, if you have an urge to visit Rottnest Island, and you live less than a kilometre or twenty minutes walk from a train station, you will walk from your current location to the nearest train station, and catch a train toward the ferry terminal. If you're not close to the Fremantle Train Line, you may first need to catch another train to Perth Station (Stop No: 99007) or Perth Underground Station (Stop number 99601) and then catch a Fremantle Line train from Perth Station.
See the Clarifications.

This task asks you to write a shellscript accepting two command-line arguments representing the latitude and longitude of your current location. Using the Google Transit Feed Specification (GTFS) data, your shellscript should first determine if your location is within one kilometre of a train station, and then determine the sequence of times and train stations required to get you to the ferry terminal. You're ready to leave at the time you run the shellscript!
The output of the shellscript will be an HTML (text) webpage, reporting whether your impulsive dash to Rottnest is possible, and the instructions/directions to get you there. Buses given you motion-sickness, so you can only travel by a combination of walking and train.
Be warned that the last ferry to Rottnest Island leaves at 15:30pm, so you'll need to ensure that you can catch it!


Outcome:

I was tasked with writing a shellscript accepting two command-line arguments representing the latitude and longitude of the current location of user. Using the Google Transit Feed Specification (GTFS) data, the shellscript should first determine if user location was within one kilometre of a train station, and then determine the sequence of times and train stations required for the user to get to the ferry terminal that leads to Rottnest Island (near Perth,WA).
