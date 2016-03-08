# VSinatra
This proof-of-concept [Sinatra](http://www.sinatrarb.com) application uses [Vaadin Elements](http://vaadin.com/elements). Expect the majority of the code to be refactored heavily.

## Supported components
* ComboBox
* Grid
* DatePicker

## Major todos
* Support storing value of a component between requests.
* Type of the component should determine available methods.
* Reusable parts should be placed in a gem.

## Limitations
There is plenty of them. For those not listed, file an issue.
Major limitations:
* An object must have a valid `to_json` implementation.
* JS code is somewhat hardcoded into the view, whereas it should be in a helper.
* There is currently no way to fetch the data from the view to the application once a request has been done.
