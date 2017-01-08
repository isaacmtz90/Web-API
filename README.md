# EventsLocator Web-API Service

[ ![Codeship Status for soa2016t6/Web-API](https://app.codeship.com/projects/f8c65920-8564-0134-0e96-0ea196d1355a/status?branch=master)](https://app.codeship.com/projects/183356)

### Prerequisites

Please Run
```
Bundle Install
```
Get an Authorization Code from MeetUp (https://www.meetup.com/meetup_api/)

GO to config/secrets.yml and add your API_KEY.
```
 development:
   MEETUP_API_KEY: ''
 test:
   MEETUP_API_KEY: ''
```
Get a set of your AWS, Google and Every8D credentials


## Getting Started

To run the API please use the command
```
rackup
```

## API Usage

Search events by City id (use 0 for "all") and Query:
```
api/v0.1/events/search/:city_id/:query
```

Search events by City
```
api/v0.1/city/:id/events/?
```

Search cities:
```
api/v0.1/cities
```

Search a city:
{Coming soon}

Example:
```
api/v0.1/city/1/events
```

##Online Deployed version:

http://meetup-event-mapper.herokuapp.com/

# License
MIT LICENSE

Copyright (c) Team Seis, SOA <imtz0b@gmail.com>

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
