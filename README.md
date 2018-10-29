# Q
Test project, splitted up into 2 repos: [front-end](https://github.com/Echoes93/Qlient) and [back-end](https://github.com/Echoes93/Q). Both are deployed to Heroku and available at http://qlient.herokuapp.com/.

## What`s all this about?
The goal of project is to create custom key-value collection type, and provide a web interface to store data within such collection. It also must must provide the ability to get live updates, whenever collection changes its state.

### Collection
Such collection is implemented as a list of tuples, where first element represents key and second represents value -> [`Q.Collection`](https://github.com/Echoes93/Q/blob/master/lib/q/collection.ex). 
This looks pretty much the same as [`Keyword`](https://hexdocs.pm/elixir/Keyword.html), with the exception that only atoms are allowed to use as keys in `Keyword`, whereas custom allows use of any data type, even `nil` and references. Of course, such collection is nowhere near the performance of traditional [`Map`](https://hexdocs.pm/elixir/Map.html) and `Keyword`, but that's not the case of the project. 

### State Container
The internal state of application is represented by [`Q.StateStore`](https://github.com/Echoes93/Q/blob/master/lib/q/state_store.ex), and whenever any of create, update or delete operations performed, it fires corresponding [`EventBus`](https://hexdocs.pm/event_bus/EventBus.html) event.


### WebSockets API
Web interface is implemented via [`Phoenix.Channels`](https://hexdocs.pm/phoenix/channels.html), and among common **C**reate, **R**ead, **U**pdate, **D**elete operations, it also processes and forwards `Q.StateStore` events to all subscribers.
