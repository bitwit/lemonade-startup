/*
  Convenience Functions
*/

var Device, appModule, clone, shuffle, user_agent;

clone = function(obj) {
  var key, temp;
  if (obj === null || typeof obj !== "object") {
    return obj;
  }
  temp = new obj.constructor();
  for (key in obj) {
    temp[key] = clone(obj[key]);
  }
  return temp;
};

shuffle = function(array) {
  var counter, index, temp;
  counter = array.length;
  while (counter > 0) {
    index = Math.floor(Math.random() * counter);
    counter--;
    temp = array[counter];
    array[counter] = array[index];
    array[index] = temp;
  }
  return array;
};

/*
  Device setup
*/


user_agent = navigator.userAgent;

Device = {
  isAndroid: user_agent.toLowerCase().indexOf("android") >= 0,
  isIOS: (user_agent.match(/iPhone/i) || user_agent.match(/iPod/i) || user_agent.match(/iPad/i)) != null
};

Device.isMobile = Device.isAndroid || Device.isIOS;

/*
  Begin Angular
*/


appModule = angular.module('appModule', ['cfp.hotkeys', 'ngRoute', 'ngTouch', 'ngAnimate', 'ngDragDrop']);

appModule.config([
  'hotkeysProvider', function(hotkeysProvider) {
    console.log('configuring cheat sheet to no');
    return hotkeysProvider.includeCheatSheet = false;
  }
]);

appModule.controller('MainController', [
  '$scope', '$rootScope', '$timeout', 'BusinessObject', 'hotkeys', function($scope, $rootScope, $timeout, bizObj, hotkeys) {
    $scope.testMessage = "Successfully using AngularJS!";
    hotkeys.add("1", "Development", function() {
      return $scope.selectedTaskIndex = 0;
    });
    hotkeys.add("2", "Research", function() {
      return $scope.selectedTaskIndex = 1;
    });
    hotkeys.add("3", "Marketing", function() {
      return $scope.selectedTaskIndex = 2;
    });
    hotkeys.add("4", "Design", function() {
      return $scope.selectedTaskIndex = 3;
    });
    hotkeys.add("5", "Sales", function() {
      return $scope.selectedTaskIndex = 4;
    });
    hotkeys.add("6", "Fundraising", function() {
      return $scope.selectedTaskIndex = 5;
    });
    hotkeys.add("space", "Resume/Confirm", function() {
      console.log("resume simulation");
      return $scope.resumeSimulation();
    });
    $scope.selectedTaskIndex = 0;
    $scope.setSelectedTaskIndex = function(index) {
      return $scope.selectedTaskIndex = index;
    };
    $scope.getCurrentSelectedTask = function() {
      var task;
      task = $scope.tasks[$scope.selectedTaskIndex];
      return clone(task);
    };
    $scope.taskListOptions = {
      accept: function(dragEl) {
        return false;
      },
      helper: 'clone'
    };
    $scope.sprintDays = [
      {
        name: "Monday",
        tasks: []
      }, {
        name: "Tuesday",
        tasks: []
      }, {
        name: "Wednesday",
        tasks: []
      }, {
        name: "Thursday",
        tasks: []
      }, {
        name: "Friday",
        tasks: []
      }, {
        name: "Saturday",
        tasks: []
      }, {
        name: "Sunday",
        tasks: []
      }, {
        name: "Monday",
        tasks: []
      }, {
        name: "Tuesday",
        tasks: []
      }, {
        name: "Wednesday",
        tasks: []
      }, {
        name: "Thursday",
        tasks: []
      }, {
        name: "Friday",
        tasks: []
      }, {
        name: "Saturday",
        tasks: []
      }, {
        name: "Sunday",
        tasks: []
      }
    ];
    $scope.prices = [0, 0.5, 1, 1.5, 2, 3, 4, 5, 7, 10];
    $scope.price = 3;
    $scope.sprint = 1;
    $scope.progress = 0;
    $scope.currentDay = -1;
    $scope.timerPromise = null;
    $scope.hasStarted = false;
    $scope.getDayPlan = function() {
      return console.log($scope.sprintDays);
    };
    $scope.startSimulation = function() {
      $scope.hasStarted = true;
      $scope.currentDay = 0;
      $scope.sprintDays[$scope.currentDay].price = $scope.prices[$scope.price];
      return $scope.tick();
    };
    $scope.resumeSimulation = function() {
      if ($scope.hasStarted && ($scope.timerPromise == null)) {
        $scope.announcements = [];
        return $scope.tick();
      }
    };
    $scope.tick = function() {
      var didCompleteDay, shouldPause;
      $scope.progress += 0.1;
      didCompleteDay = false;
      if ($scope.progress > 10) {
        didCompleteDay = true;
        shouldPause = bizObj.dayComplete($scope.sprintDays[$scope.currentDay]);
        $scope.progress = 0.1;
        $scope.currentDay++;
      }
      if ($scope.currentDay >= 14) {
        console.log('sprint simulation complete');
        bizObj.sprintComplete($scope.sprint);
        return $scope.nextSprint();
      } else {
        if (didCompleteDay) {
          $scope.sprintDays[$scope.currentDay].price = $scope.prices[$scope.price];
        }
        if (!shouldPause) {
          return $scope.timerPromise = $timeout($scope.tick, 40);
        } else {
          return $scope.timerPromise = null;
        }
      }
    };
    $scope.nextSprint = function() {
      var day, _i, _len, _ref, _results;
      $scope.sprint++;
      $scope.currentDay = -1;
      $scope.progress = 0;
      _ref = $scope.sprintDays;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        day = _ref[_i];
        _results.push(day.tasks = []);
      }
      return _results;
    };
    $scope.setTasks = function() {
      return $scope.tasks = [new DevelopmentCard(), new ResearchCard(), new MarketingCard(), new DesignCard(), new SalesCard(), new FundraisingCard()];
    };
    $rootScope.announceEvent = function(event) {
      return $rootScope.announcements = [event];
    };
    $scope.$on('taskMoved', function($e, task) {
      return console.log('main controller task moved');
    });
    return $scope.setTasks();
  }
]);

appModule.directive('lsDay', [
  function() {
    return {
      replace: true,
      link: function(scope, element, attrs, ctrl) {
        console.log('sprint day link');
        return element.dayObject = scope.day;
      },
      controller: [
        "$scope", "$rootScope", "$timeout", function($scope, $rootScope, $timeout) {
          $scope.sprintDayDraggableOut = function(e, el) {};
          $scope.taskOnDrop = function(e, el, a) {
            var task;
            task = el.draggable[0].taskObject;
            console.log('new task for', $scope.day.name, task);
            return $rootScope.$broadcast('newTaskForDay', task, $scope.day);
          };
          $scope.message = null;
          $scope.addSelectedTask = function() {
            var task;
            if ($scope.day.tasks.length < 2) {
              task = $scope.getCurrentSelectedTask();
              $scope.day.tasks.push(task);
              return $rootScope.$broadcast('newTaskForDay', task, $scope.day);
            }
          };
          $scope.sprintDayOptions = function(index) {
            return {
              accept: function(dragEl) {
                if ($scope.currentDay >= index) {
                  return false;
                }
                if ($scope.day.$$hashKey === dragEl[0].attributes["data-day"].value) {
                  return false;
                }
                if ($scope.day.tasks.length >= 2) {
                  return false;
                }
                return true;
              }
            };
          };
          $scope.progressMeterStyles = function(index) {
            var width;
            if ($scope.currentDay > index) {
              width = "100%";
            } else if ($scope.currentDay === index) {
              width = ($scope.progress * 10) + "%";
            } else {
              width = 0;
            }
            return {
              width: width
            };
          };
          $scope.day.announce = function(text) {
            console.log('announcing text', $scope.day, text);
            $scope.message = text;
            return $timeout(function() {
              return $scope.message = null;
            }, 1000);
          };
          $scope.removeTask = function(e, task) {
            var dayTask, leftOverTasks, _i, _len, _ref;
            if (e != null) {
              e.stopPropagation();
              e.preventDefault();
            }
            leftOverTasks = [];
            _ref = $scope.day.tasks;
            for (_i = 0, _len = _ref.length; _i < _len; _i++) {
              dayTask = _ref[_i];
              if (task !== dayTask) {
                leftOverTasks.push(dayTask);
              }
            }
            return $scope.day.tasks = leftOverTasks;
          };
          $scope.$on('newTaskForDay', function($e, task, day) {
            if (day === $scope.day) {
              return;
            }
            return $scope.removeTask(null, task);
          });
          return $scope.$on('taskMoved', function($e, task) {
            /*
            console.log 'task is moving', task, $scope.day.tasks
            */

          });
        }
      ],
      template: "<div class=\"day full-{{day.tasks.length >= 2}}\" ng-click=\"addSelectedTask()\" data-drop=\"true\" ng-model=\"day.tasks\" data-jqyoui-options=\"sprintDayOptions($index)\" jqyoui-droppable=\"{onDrop:'taskOnDrop', multiple:true}\">\n    <div class=\"day-progress-meter\" ng-style=\"progressMeterStyles($index)\"></div>\n    <div class=\"message showing-{{(message != null)}}\">\n      <span class=\"value\">{{message}}</span>\n    </div>\n    <h5 class=\"day-name\">{{day.name}}</h5>\n    <div ng-repeat=\"task in day.tasks track by $index\" ls-task></div>\n</div>"
    };
  }
]);

appModule.directive('lsJob', [
  function() {
    return {
      replace: true,
      link: function(scope, element, attrs, ctrl) {
        return element[0].taskObject = scope.task;
      },
      controller: [
        "$scope", "$rootScope", function($scope, $rootScope) {
          $scope.dragStop = function() {
            return $scope.$emit('taskMoved', $scope.task);
          };
          return $scope.selected = function(index) {
            return $scope.setSelectedTaskIndex(index);
          };
        }
      ],
      template: "<div class=\"job type-{{task.id}} selected-{{selectedTaskIndex == $index}} oi\" ng-click=\"selected($index)\" data-glyph=\"{{task.icon}}\" data-drag=\"{{true}}\" data-day=\"{{day.$$hashKey}}\" data-jqyoui-options=\"{revert:'invalid'}\" ng-model=\"task\" jqyoui-draggable=\"{index: {{$index}}, onStop: 'dragStop', placeholder:'keep'}\">\n  <span class=\"title\">{{task.name}}</span>\n  <span class=\"hotkey-button\">{{$index + 1}}</span>\n</div>"
    };
  }
]);

appModule.directive('lsTask', [
  function() {
    return {
      replace: true,
      link: function(scope, element, attrs, ctrl) {
        return element[0].taskObject = scope.task;
      },
      controller: [
        "$scope", "$rootScope", function($scope, $rootScope) {
          return $scope.dragStop = function() {
            console.log('task', $scope.day.name, $scope.task);
            return $scope.$emit('taskMoved', $scope.task);
          };
        }
      ],
      template: "<div class=\"task type-{{task.id}} oi\" data-glyph=\"{{task.icon}}\" data-drag=\"{{true}}\" data-day=\"{{day.$$hashKey}}\" data-jqyoui-options=\"{revert: 'invalid', placeholder:true}\" ng-model=\"task\" jqyoui-draggable=\"{index: {{$index}}, placeholder:'keep', onStop: 'dragStop'}\">\n  <span class=\"title\">{{task.id}}</span>\n  <span ng-click=\"removeTask($event, task)\" class=\"delete\">X</span>\n</div>"
    };
  }
]);

var Card, DesignCard, DevelopmentCard, FundraisingCard, MarketingCard, ResearchCard, SalesCard,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

Card = (function() {
  function Card(name, id, icon) {
    this.name = name;
    this.id = id;
    this.icon = icon;
    this.development = 0;
    this.design = 0;
    this.marketing = 0;
    this.research = 0;
    this.sales = 0;
    this.fundraising = 0;
    this.productivity = 0;
    this.fixedCostPerDay = 0;
    this.variableCostPerDay = 0;
    this.averageDemand = 0;
  }

  Card.prototype.merge = function(business) {
    var stats;
    stats = business.stats;
    stats.development += this.development;
    stats.design += this.design;
    stats.marketing += this.marketing;
    stats.research += this.research;
    stats.sales += this.sales;
    stats.fundraising += this.fundraising;
    stats.productivity += this.productivity;
    stats.fixedCostPerDay += this.fixedCostPerDay;
    stats.variableCostPerDay += this.variableCostPerDay;
    return stats.averageDemand += this.averageDemand;
  };

  return Card;

})();

MarketingCard = (function(_super) {
  __extends(MarketingCard, _super);

  function MarketingCard() {
    MarketingCard.__super__.constructor.call(this, "Marketing", "mkt", "target");
    this.marketing = 2;
    this.averageDemand = 10;
  }

  return MarketingCard;

})(Card);

DevelopmentCard = (function(_super) {
  __extends(DevelopmentCard, _super);

  function DevelopmentCard() {
    DevelopmentCard.__super__.constructor.call(this, "Development", "dev", "wrench");
    this.development = 2;
    this.variableCostPerDay = -0.02;
  }

  return DevelopmentCard;

})(Card);

ResearchCard = (function(_super) {
  __extends(ResearchCard, _super);

  function ResearchCard() {
    ResearchCard.__super__.constructor.call(this, "Research", "res", "lightbulb");
    this.research = 2;
    this.fixedCostPerDay = -10;
  }

  return ResearchCard;

})(Card);

DesignCard = (function(_super) {
  __extends(DesignCard, _super);

  function DesignCard() {
    DesignCard.__super__.constructor.call(this, "Design", "des", "brush");
    this.design = 2;
    this.averageDemand = 5;
    this.variableCostPerDay = 0.01;
  }

  return DesignCard;

})(Card);

SalesCard = (function(_super) {
  __extends(SalesCard, _super);

  function SalesCard() {
    SalesCard.__super__.constructor.call(this, "Sales", "sal", "graph");
    this.sales = 2;
    this.averageDemand = 20;
  }

  return SalesCard;

})(Card);

FundraisingCard = (function(_super) {
  __extends(FundraisingCard, _super);

  function FundraisingCard() {
    FundraisingCard.__super__.constructor.call(this, "Fundraising", "fun", "dollar");
    this.fundraising = 2;
  }

  return FundraisingCard;

})(Card);

var EventCard, PRAgentEventCard,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

EventCard = (function() {
  function EventCard(name, icon) {
    this.name = name;
    this.icon = icon;
    this.expiry = -1;
    this.description = "An event occurred";
    this.thresholds = {
      development: 0,
      design: 0,
      marketing: 0,
      research: 0,
      sales: 0,
      fundraising: 0,
      productivity: 0,
      cash: 0
    };
  }

  EventCard.prototype.hasBusinessMetConditions = function(business) {
    var stat, thresholdsMet, value, _ref;
    thresholdsMet = true;
    _ref = this.thresholds;
    for (stat in _ref) {
      value = _ref[stat];
      if (value !== 0 && business.stats[stat] < value) {
        thresholdsMet = false;
      }
    }
    return thresholdsMet;
  };

  EventCard.prototype.tick = function(business, tasks) {
    var index;
    if (this.expiry === -1) {
      return true;
    } else {
      this.expiry--;
      if (this.expiry <= 0) {
        index = business.assets.indexOf(this);
        return business.assets.splice(index, 1);
      }
    }
  };

  return EventCard;

})();

PRAgentEventCard = (function(_super) {
  __extends(PRAgentEventCard, _super);

  function PRAgentEventCard() {
    PRAgentEventCard.__super__.constructor.call(this, "PR Agent", "rss");
    this.description = "A PR Agent has agreed to help work with your team for the next few days";
    this.expiry = 3;
    this.thresholds.marketing = 2;
  }

  PRAgentEventCard.prototype.tick = function(business, tasks) {
    var task, _i, _len;
    PRAgentEventCard.__super__.tick.call(this, business, tasks);
    for (_i = 0, _len = tasks.length; _i < _len; _i++) {
      task = tasks[_i];
      task.marketing = task.marketing * 1.5;
    }
    return business.stats.marketing += 1;
  };

  return PRAgentEventCard;

})(EventCard);

var AverageWeatherCard, ColdWeatherCard, GoodWeatherCard, HeatWaveWeatherCard, RainyWeatherCard, WeatherCard,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

WeatherCard = (function() {
  function WeatherCard() {
    this.description = "Weather description";
    this.fixedCostPerDay = 1.0;
    this.variableCostPerDay = 1.0;
    this.averageDemand = 1.0;
  }

  return WeatherCard;

})();

HeatWaveWeatherCard = (function(_super) {
  __extends(HeatWaveWeatherCard, _super);

  function HeatWaveWeatherCard() {
    HeatWaveWeatherCard.__super__.constructor.call(this);
    this.averageDemand = 2.0;
    this.description = "Blisteringly hot out today.";
  }

  return HeatWaveWeatherCard;

})(WeatherCard);

GoodWeatherCard = (function(_super) {
  __extends(GoodWeatherCard, _super);

  function GoodWeatherCard() {
    GoodWeatherCard.__super__.constructor.call(this);
    this.averageDemand = 1.2;
    this.description = "It's a beautiful day outside";
  }

  return GoodWeatherCard;

})(WeatherCard);

AverageWeatherCard = (function(_super) {
  __extends(AverageWeatherCard, _super);

  function AverageWeatherCard() {
    AverageWeatherCard.__super__.constructor.call(this);
    this.description = "Fair weather outside today";
  }

  return AverageWeatherCard;

})(WeatherCard);

RainyWeatherCard = (function(_super) {
  __extends(RainyWeatherCard, _super);

  function RainyWeatherCard() {
    RainyWeatherCard.__super__.constructor.call(this);
    this.averageDemand = 0.5;
    this.description = "It's very rainy out today";
  }

  return RainyWeatherCard;

})(WeatherCard);

ColdWeatherCard = (function(_super) {
  __extends(ColdWeatherCard, _super);

  function ColdWeatherCard() {
    ColdWeatherCard.__super__.constructor.call(this);
    this.averageDemand = 0.5;
    this.description = "It's freezing outside";
  }

  return ColdWeatherCard;

})(WeatherCard);

appModule.service("BusinessObject", [
  "$rootScope", function($rootScope) {
    var businessObject, eventCards, weatherCards;
    eventCards = [new PRAgentEventCard()];
    weatherCards = [new HeatWaveWeatherCard(), new GoodWeatherCard(), new RainyWeatherCard(), new ColdWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard()];
    businessObject = {
      forecast: [],
      stats: {
        cash: 50000,
        projectedValue: 0,
        development: 0,
        design: 0,
        marketing: 0,
        research: 0,
        sales: 0,
        fundraising: 0,
        productivity: 0,
        fixedCostPerDay: 500,
        variableCostPerDay: 0.20,
        averageDemand: 200,
        potentialMarketSize: 1000
      },
      assets: [],
      dailyRevenueHistory: []
    };
    businessObject.dayComplete = function(day) {
      var asset, card, cashDelta, didTriggerEvent, event, eventCard, i, stats, weather, _i, _j, _k, _len, _len1, _len2, _ref, _ref1;
      console.log('day complete', day);
      _ref = businessObject.assets;
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        asset = _ref[_i];
        asset.tick(businessObject, day.tasks);
      }
      _ref1 = day.tasks;
      for (_j = 0, _len1 = _ref1.length; _j < _len1; _j++) {
        card = _ref1[_j];
        card.merge(businessObject);
      }
      didTriggerEvent = false;
      for (i = _k = 0, _len2 = eventCards.length; _k < _len2; i = ++_k) {
        eventCard = eventCards[i];
        if (eventCard.hasBusinessMetConditions(businessObject)) {
          didTriggerEvent = true;
          event = eventCards.splice(i, 1)[0];
          businessObject.assets.push(event);
          $rootScope.announceEvent(event);
        }
      }
      weather = businessObject.forecast.shift();
      stats = businessObject.stats;
      cashDelta = 0;
      cashDelta -= stats.fixedCostPerDay;
      cashDelta -= stats.averageDemand * weather.averageDemand * stats.variableCostPerDay;
      cashDelta += stats.averageDemand * weather.averageDemand * day.price;
      stats.cash = stats.cash + cashDelta;
      businessObject.dailyRevenueHistory.push(cashDelta);
      console.log(businessObject.dailyRevenueHistory);
      day.announce("$" + cashDelta);
      businessObject.predictBusinessValue();
      businessObject.generateForecast();
      return didTriggerEvent;
    };
    businessObject.sprintComplete = function(sprintNumber) {
      console.log("Sprint " + sprintNumber + " completed");
      return businessObject.setCosts(sprintNumber);
    };
    businessObject.generateForecast = function() {
      while (businessObject.forecast.length < 3) {
        shuffle(weatherCards);
        businessObject.forecast.push(weatherCards.pop());
      }
      return weatherCards = weatherCards.concat(businessObject.forecast);
    };
    businessObject.setCosts = function(sprintNumber) {
      var stats;
      stats = businessObject.stats;
      return stats.fixedCostPerDay = 50 * sprintNumber;
    };
    businessObject.setSprintModifiers = function(sprintNUmber) {
      if (sprintNUmber > 3) {

      } else {

      }
      if (sprintNUmber > 6) {

      } else {

      }
    };
    businessObject.predictBusinessValue = function() {
      var developmentModifier, marketingModifier, newValue, researchModifier, stats;
      newValue = 0;
      stats = businessObject.stats;
      console.log("Current Stats:");
      console.log("average demand:", stats.averageDemand);
      console.log("fixed costs:", stats.fixedCostPerDay);
      console.log("variable costs:".stats.variableCostPerDay);
      marketingModifier = stats.marketing + 1;
      developmentModifier = stats.development + 1;
      researchModifier = stats.research + 1;
      newValue = stats.cash + (businessObject.getRevenueHistory(7) * 52 * 0.25) + (stats.averageDemand * marketingModifier * developmentModifier) + (researchModifier * developmentModifier) + (stats.fundraising * -0.1);
      return stats.projectedValue = newValue;
    };
    businessObject.getRevenueHistory = function(interval) {
      var entry, i, runningTotal, _i, _j, _len, _ref;
      runningTotal = 0;
      if (businessObject.dailyRevenueHistory.length >= interval) {
        for (i = _i = 0; 0 <= interval ? _i < interval : _i > interval; i = 0 <= interval ? ++_i : --_i) {
          runningTotal += businessObject.dailyRevenueHistory[businessObject.dailyRevenueHistory.length - (interval - i)];
        }
      } else if (businessObject.dailyRevenueHistory.length === 0) {
        console.log("No entries in Daily Revenue History");
      } else {
        _ref = businessObject.dailyRevenueHistory;
        for (_j = 0, _len = _ref.length; _j < _len; _j++) {
          entry = _ref[_j];
          runningTotal += entry;
        }
      }
      console.log("runningtotal", runningTotal);
      return runningTotal;
    };
    businessObject.generateForecast();
    $rootScope.game = businessObject;
    console.log('starting forecast', businessObject.forecast);
    return businessObject;
  }
]);
