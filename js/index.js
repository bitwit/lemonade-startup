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

appModule.controller("RootController", [
  "$rootScope", function($rootScope) {
    $rootScope.currentView = "intro";
    return $rootScope.switchView = function(viewName) {
      return $rootScope.currentView = viewName;
    };
  }
]);

appModule.controller('IntroController', ['$scope', function($scope) {}]);

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
    $scope.sprintDays = [
      {
        name: "Monday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Tuesday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Wednesday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Thursday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Friday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Saturday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Sunday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Monday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Tuesday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Wednesday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Thursday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Friday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Saturday",
        tasks: [],
        isInteractive: true,
        price: null
      }, {
        name: "Sunday",
        tasks: [],
        isInteractive: true,
        price: null
      }
    ];
    $scope.tasks = [new DevelopmentCard(), new ResearchCard(), new MarketingCard(), new DesignCard(), new SalesCard(), new FundraisingCard()];
    $scope.prices = [0, 0.5, 1, 1.5, 2, 3, 4, 5, 7, 10];
    $scope.price = 3;
    $scope.sprint = 1;
    $scope.maxSprints = 10;
    $scope.currentDay = -1;
    $scope.progress = 0;
    $scope.timerPromise = null;
    $scope.hasStarted = false;
    $scope.tickSpeed = 40;
    $scope.selectedTaskIndex = 0;
    $scope.countdownProgress = 0;
    $scope.announcements = [];
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
    $scope.getDayPlan = function() {
      return console.log($scope.sprintDays);
    };
    $scope.startCountdown = function() {
      $scope.countdownProgress = 15000;
      return $timeout($scope.tickCountdown, $scope.tickSpeed);
    };
    $scope.tickCountdown = function() {
      $scope.countdownProgress -= $scope.tickSpeed;
      if ($scope.countdownProgress <= 0) {
        $scope.countdownProgress = 0;
        return $scope.startSimulation();
      } else {
        return $timeout($scope.tickCountdown, $scope.tickSpeed);
      }
    };
    $scope.startSimulation = function() {
      var day;
      $scope.hasStarted = true;
      $scope.currentDay = 0;
      day = $scope.sprintDays[$scope.currentDay];
      day.price = $scope.prices[$scope.price];
      day.isInteractive = false;
      return $scope.tick();
    };
    $scope.autoPopulateDays = function() {
      var day, _i, _len, _ref, _results;
      _ref = $scope.sprintDays;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        day = _ref[_i];
        _results.push((function() {
          var _results1;
          _results1 = [];
          while (day.tasks.length < 2) {
            $scope.selectedTaskIndex = Math.floor(Math.random() * 6);
            _results1.push(day.tasks.push($scope.getCurrentSelectedTask()));
          }
          return _results1;
        })());
      }
      return _results;
    };
    $scope.resumeSimulation = function() {
      if ($scope.hasStarted && ($scope.timerPromise == null)) {
        $scope.announcements.length = 0;
        return $scope.tick();
      }
    };
    $scope.tick = function() {
      var day, didCompleteDay, newPrice, shouldPause;
      $scope.progress += 0.1;
      didCompleteDay = false;
      if ($scope.progress > 10) {
        didCompleteDay = true;
        shouldPause = bizObj.dayComplete($scope.sprintDays[$scope.currentDay]);
        $scope.progress = 0.1;
        $scope.currentDay++;
      }
      if ($scope.currentDay > 13) {
        console.log('sprint simulation complete');
        bizObj.sprintComplete($scope.sprint);
        return $scope.nextSprint();
      } else {
        if (didCompleteDay) {
          day = $scope.sprintDays[$scope.currentDay];
          newPrice = $scope.prices[$scope.price];
          console.log('NEW PRICE, PRICE INDEX', newPrice, $scope.price);
          day.price = newPrice;
          day.isInteractive = false;
        }
        if (!shouldPause) {
          return $scope.timerPromise = $timeout($scope.tick, $scope.tickSpeed);
        } else {
          return $scope.timerPromise = null;
        }
      }
    };
    $scope.nextSprint = function() {
      var day, _i, _len, _ref;
      $scope.sprint++;
      if ($scope.sprint > $scope.maxSprints) {
        return $rootScope.switchView('end');
      } else {
        $scope.currentDay = -1;
        $scope.progress = 0;
        _ref = $scope.sprintDays;
        for (_i = 0, _len = _ref.length; _i < _len; _i++) {
          day = _ref[_i];
          day.tasks = [];
          day.isInteractive = true;
        }
        return $scope.startCountdown();
      }
    };
    $scope.$on('eventCardOccured', function($e, eventCard) {
      $scope.announcements.length = 0;
      $scope.announcements.push(eventCard);
      return console.log('announcements', $scope.announcements);
    });
    $scope.$on('taskMoved', function($e, task) {
      return console.log('main controller task moved');
    });
    return $scope.startCountdown();
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
          $scope.taskOnDrop = function(e, el) {
            var task;
            task = el.draggable[0].taskObject;
            console.log('new task for', $scope.day.name, task);
            return $rootScope.$broadcast('newTaskForDay', task, $scope.day);
          };
          $scope.message = null;
          $scope.addSelectedTask = function() {
            var task;
            if ($scope.day.tasks.length < 2 && $scope.day.isInteractive) {
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
          $scope.isShowingMessage = false;
          $scope.day.announce = function(text) {
            console.log('announcing text', $scope.day, text);
            $scope.message = text;
            $scope.isShowingMessage = true;
            return $timeout(function() {
              return $scope.isShowingMessage = false;
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
      template: "<div class=\"day full-{{day.tasks.length >= 2}}\" ng-click=\"addSelectedTask()\" data-drop=\"true\" ng-model=\"day.tasks\" data-jqyoui-options=\"sprintDayOptions($index)\" jqyoui-droppable=\"{onDrop:'taskOnDrop', multiple:true}\">\n    <div class=\"day-progress-meter\" ng-style=\"progressMeterStyles($index)\"></div>\n    <div class=\"message showing-{{(isShowingMessage)}}\">\n      <span class=\"value\">{{message | currency:\"$\"}}</span>\n    </div>\n    <h5 class=\"day-name\">{{day.name}}</h5>\n    <div ng-repeat=\"task in day.tasks track by $index\" ls-task></div>\n</div>"
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
      template: "<div class=\"job type-{{task.id}} selected-{{selectedTaskIndex == $index}} oi\" ng-click=\"selected($index)\" data-glyph=\"{{task.icon}}\" data-drag=\"{{true}}\" data-day=\"{{day.$$hashKey}}\" data-jqyoui-options=\"{revert:'invalid'}\" ng-model=\"task\" jqyoui-draggable=\"{index: {{$index}}, onStop: 'dragStop', placeholder:'keep'}\">\n  <span class=\"title\">{{task.id}}</span>\n  <span class=\"hotkey-button\">{{$index + 1}}</span>\n</div>"
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
          $scope.dragStart = function(e, el) {
            console.log('dragStart', e, el);
            if (!$scope.day.isInteractive) {
              e.preventDefault();
              e.stopPropagation();
              return el.helper.draggable("option", "disabled", true);
            }
          };
          return $scope.dragStop = function() {
            console.log('task', $scope.day.name, $scope.task);
            return $scope.$emit('taskMoved', $scope.task);
          };
        }
      ],
      template: "<div class=\"task type-{{task.id}} oi\" data-glyph=\"{{task.icon}}\" data-drag=\"{{true}}\" data-day=\"{{day.$$hashKey}}\" data-jqyoui-options=\"{revert: 'invalid', placeholder:true}\" ng-model=\"task\" jqyoui-draggable=\"{index: {{$index}}, placeholder:'keep', onStart: 'dragStart', onStop: 'dragStop'}\">\n  <span class=\"title\">{{task.id}}</span>\n  <span ng-if=\"day.isInteractive\" ng-click=\"removeTask($event, task)\" class=\"delete oi\" data-glyph=\"trash\"></span>\n</div>"
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

var BrandAmbassadorCard, CaffinatedLemonsCard, CrowdfundingCampaignCard, EventCard, GoneViralCardGood, GreatSalesPitchCard, MoneyFromDadCard, PRAgentEventCard, ProductMarketFitCard, SeedInvestmentCard,
  __hasProp = {}.hasOwnProperty,
  __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

EventCard = (function() {
  function EventCard(name, id, icon) {
    this.name = name;
    this.id = id;
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
    PRAgentEventCard.__super__.constructor.call(this, "PR Agent", "mkt", "rss");
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

GoneViralCardGood = (function(_super) {
  __extends(GoneViralCardGood, _super);

  function GoneViralCardGood() {
    GoneViralCardGood.__super__.constructor.call(this, "Gone Viral", "mkt", "rss");
    this.description = "A youtube video you made now has 10,000,000 views. That has to be good for something, right?";
    this.expiry = 3;
    this.thresholds.marketing = 3;
  }

  GoneViralCardGood.prototype.tick = function(business, tasks) {
    var task, _i, _len;
    GoneViralCardGood.__super__.tick.call(this, business, tasks);
    for (_i = 0, _len = tasks.length; _i < _len; _i++) {
      task = tasks[_i];
      task.marketing = task.marketing * 1.5;
    }
    business.stats.marketing += 3;
    return business.stats.cash += 10;
  };

  return GoneViralCardGood;

})(EventCard);

ProductMarketFitCard = (function(_super) {
  __extends(ProductMarketFitCard, _super);

  function ProductMarketFitCard() {
    ProductMarketFitCard.__super__.constructor.call(this, "Product Market Fit", "res", "graph");
    this.description = "Word from our market research team is looking good...";
    this.expiry = 0;
    this.thresholds.research = 5;
  }

  ProductMarketFitCard.prototype.tick = function(business, tasks) {
    ProductMarketFitCard.__super__.tick.call(this, business, tasks);
    return business.stats.potentialMarketSize += 1000;
  };

  return ProductMarketFitCard;

})(EventCard);

MoneyFromDadCard = (function(_super) {
  __extends(MoneyFromDadCard, _super);

  function MoneyFromDadCard() {
    MoneyFromDadCard.__super__.constructor.call(this, "$200 From Dad", "fun", "credit-card");
    this.description = "Your Dad doesn't want you to starve. Or eat too much.";
    this.expiry = 0;
    this.thresholds.cash = 100;
  }

  MoneyFromDadCard.prototype.tick = function(business, tasks) {
    MoneyFromDadCard.__super__.tick.call(this, business, tasks);
    return business.stats.cash += 200;
  };

  return MoneyFromDadCard;

})(EventCard);

CrowdfundingCampaignCard = (function(_super) {
  __extends(CrowdfundingCampaignCard, _super);

  function CrowdfundingCampaignCard() {
    CrowdfundingCampaignCard.__super__.constructor.call(this, "Kick my Lemons", "fun", "credit-card");
    this.description = "Our crowdfunding campaign took off! People really want your lemonade. Or at least the t-shirt.";
    this.expiry = 0;
    this.thresholds.marketing = 5;
    this.thresholds.fundraising = 10;
  }

  CrowdfundingCampaignCard.prototype.tick = function(business, tasks) {
    CrowdfundingCampaignCard.__super__.tick.call(this, business, tasks);
    business.stats.cash += 5000;
    return business.stats.marketing += 5;
  };

  return CrowdfundingCampaignCard;

})(EventCard);

SeedInvestmentCard = (function(_super) {
  __extends(SeedInvestmentCard, _super);

  function SeedInvestmentCard() {
    SeedInvestmentCard.__super__.constructor.call(this, "Ignore the Horns", "fun", "credit-card");
    this.description = "A lovely gentleman with a dashing goatee offered some seed money...";
    this.expiry = -1;
    this.thresholds.fundraising = 15;
  }

  SeedInvestmentCard.prototype.tick = function(business, tasks) {
    SeedInvestmentCard.__super__.tick.call(this, business, tasks);
    business.stats.cash += 20000;
    return business.stats.equity -= 10;
  };

  return SeedInvestmentCard;

})(EventCard);

GreatSalesPitchCard = (function(_super) {
  __extends(GreatSalesPitchCard, _super);

  function GreatSalesPitchCard() {
    GreatSalesPitchCard.__super__.constructor.call(this, "Silver Tongue", "sal", "comment-square");
    this.description = "Your pitch is so practiced, even the mirror is thirsty.";
    this.expiry = 0;
    this.thresholds.sales = 3;
  }

  GreatSalesPitchCard.prototype.tick = function(business, tasks) {
    GreatSalesPitchCard.__super__.tick.call(this, business, tasks);
    return business.stats.marketing += 5;
  };

  return GreatSalesPitchCard;

})(EventCard);

BrandAmbassadorCard = (function(_super) {
  __extends(BrandAmbassadorCard, _super);

  function BrandAmbassadorCard() {
    BrandAmbassadorCard.__super__.constructor.call(this, "Brand Ambassador", "sal", "musical-note");
    this.description = "Turns out, 50 Cent's cousin's friend likes our lemonade! She's agreed to represent us for a few days.";
    this.expiry = 5;
    this.thresholds.marketing = 5;
    this.thresholds.sales = 5;
  }

  BrandAmbassadorCard.prototype.tick = function(business, tasks) {
    var task, _i, _len;
    BrandAmbassadorCard.__super__.tick.call(this, business, tasks);
    for (_i = 0, _len = tasks.length; _i < _len; _i++) {
      task = tasks[_i];
      task.marketing = task.marketing * 2;
      task.sales = task.sales * 1.5;
    }
    business.stats.marketing += 5;
    return business.stats.potentialMarketSize += 1000;
  };

  return BrandAmbassadorCard;

})(EventCard);

CaffinatedLemonsCard = (function(_super) {
  __extends(CaffinatedLemonsCard, _super);

  function CaffinatedLemonsCard() {
    CaffinatedLemonsCard.__super__.constructor.call(this, "Caffinated Lemons", "dev", "comment-square");
    this.description = "How diddddn't we thinkkk of thss bbbeforre?? Why wn'tttt mmy knee stop shhhhaking?";
    this.expiry = 0;
    this.thresholds.development = 10;
  }

  CaffinatedLemonsCard.prototype.tick = function(business, tasks) {
    CaffinatedLemonsCard.__super__.tick.call(this, business, tasks);
    business.stats.marketing += 5;
    return business.stats.sales += 1;
  };

  return CaffinatedLemonsCard;

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
    eventCards = [new PRAgentEventCard(), new BrandAmbassadorCard(), new GreatSalesPitchCard(), new ProductMarketFitCard(), new GoneViralCardGood(), new MoneyFromDadCard(), new CrowdfundingCampaignCard(), new SeedInvestmentCard(), new CaffinatedLemonsCard()];
    weatherCards = [new HeatWaveWeatherCard(), new GoodWeatherCard(), new RainyWeatherCard(), new ColdWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard(), new AverageWeatherCard()];
    businessObject = {
      forecast: [],
      stats: {
        cash: 50,
        creditLimit: 1000,
        equity: 100,
        projectedValue: -1000,
        development: 0,
        design: 0,
        marketing: 0,
        research: 0,
        sales: 0,
        fundraising: 0,
        productivity: 0,
        fixedCostPerDay: 5,
        variableCostPerDay: 0.20,
        averageDemand: 200,
        potentialMarketSize: 1000
      },
      flags: {
        doesHaveAvailableFunds: true,
        doesHaveAvailableEquity: true,
        playerHasMajorityEquity: true,
        playerHasTotalOwnership: true,
        cashOnHandIsPositive: true,
        hasPassedHighThreshold_Cash: false,
        hasPassedHighThreshold_Research: false,
        hasPassedHighThreshold_Development: false,
        hasPassedHighThreshold_Design: false,
        hasPassedHighThreshold_Marketing: false,
        hasPassedHighThreshold_Sales: false,
        hasPassedHighThreshold_Fundraising: false,
        hasPassedHighThreshold_MarketSize: false,
        isBroke: false
      },
      tracking: {
        highestPrice: 0,
        lowestPrice: 0,
        mostCustomersInOneDay: 0,
        totalCustomers: 0,
        totalRevenue: 0,
        mostCashOnHand: 0,
        leastCashOnHand: 0
      },
      assets: [],
      dailyRevenueHistory: []
    };
    businessObject.onDayStart = function() {};
    businessObject.dayComplete = function(day) {
      var asset, card, cashDelta, didTriggerEvent, event, eventCard, i, numCustomers, stats, weather, _i, _j, _k, _len, _len1, _ref, _ref1;
      console.log('day complete', day);
      if (businessObject.assets.length > 0) {
        for (i = _i = _ref = businessObject.assets.length - 1; _ref <= 0 ? _i <= 0 : _i >= 0; i = _ref <= 0 ? ++_i : --_i) {
          console.log('get object', i);
          asset = businessObject.assets[i];
          asset.tick(businessObject, day.tasks);
        }
      }
      _ref1 = day.tasks;
      for (_j = 0, _len = _ref1.length; _j < _len; _j++) {
        card = _ref1[_j];
        card.merge(businessObject);
      }
      didTriggerEvent = false;
      for (i = _k = 0, _len1 = eventCards.length; _k < _len1; i = ++_k) {
        eventCard = eventCards[i];
        if (eventCard.hasBusinessMetConditions(businessObject)) {
          didTriggerEvent = true;
          event = eventCards.splice(i, 1)[0];
          businessObject.assets.push(event);
          $rootScope.$broadcast('eventCardOccured', event);
          break;
        }
      }
      weather = businessObject.forecast.shift();
      businessObject.stats.averageDemand = businessObject.calculateDemand(weather, day);
      numCustomers = businessObject.stats.averageDemand;
      if (numCustomers > businessObject.stats.potentialMarketSize) {
        numCustomers = businessObject.stats.potentialMarketSize;
      }
      console.log("Number of Customers:", numCustomers);
      stats = businessObject.stats;
      cashDelta = 0;
      cashDelta -= stats.fixedCostPerDay;
      cashDelta -= numCustomers * stats.variableCostPerDay;
      cashDelta += numCustomers * day.price;
      stats.cash = stats.cash + cashDelta;
      businessObject.dailyRevenueHistory.push(cashDelta);
      console.log(businessObject.dailyRevenueHistory);
      day.announce(cashDelta);
      businessObject.predictBusinessValue();
      businessObject.generateForecast();
      return didTriggerEvent;
    };
    businessObject.sprintComplete = function(sprintNumber) {
      console.log("Sprint " + sprintNumber + " completed");
      businessObject.setCosts(sprintNumber);
      businessObject.setCreditLimit();
      if (sprintNumber === 10) {
        return businessObject.processEndGame();
      }
    };
    businessObject.processEndGame = function() {
      var flags, stats;
      console.log("Game over!");
      stats = businessObject.stats;
      return flags = businessObject.flags;
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
      console.log("Updating fixed costs");
      stats = businessObject.stats;
      return stats.fixedCostPerDay += 50 * sprintNumber;
    };
    businessObject.calculateDemand = function(weather, day) {
      var demand, marketForce, neutralPrice, priceDiff, stats;
      stats = businessObject.stats;
      demand = 0;
      marketForce = stats.marketing * 2 + stats.development + stats.design * 2 + stats.research * 2;
      if (marketForce <= 0) {
        marketForce = 1;
      }
      neutralPrice = 1 + marketForce / 100;
      console.log("market force", marketForce);
      console.log("Neutral price", neutralPrice);
      priceDiff = 0;
      console.log("Price", day.price);
      if (day.price > 0) {
        priceDiff = neutralPrice / day.price;
        console.log("price diff:", priceDiff);
      } else if (day.price < 0) {
        priceDiff = neutralPrice / day.price;
        console.log("price diff:", priceDiff);
      } else {
        priceDiff = 1;
        console.log("price diff:", priceDiff);
      }
      console.log("weather effect", weather.averageDemand);
      demand = stats.potentialMarketSize * (marketForce / 100) * weather.averageDemand * priceDiff;
      if (priceDiff < 0.5) {
        demand *= 0.5;
      }
      if (priceDiff < 0.2) {
        demand *= 0.1;
      }
      console.log("demand", demand);
      return demand;
    };
    businessObject.setCreditLimit = function() {
      var newLimit, stats;
      stats = businessObject.stats;
      newLimit = stats.cash / 10 + businessObject.getRevenueHistory(7);
      if (newLimit < 1000) {
        newLimit = 1000;
      } else if (newLimit > 50000) {
        newLimit = 50000;
      }
      console.log("limit", newLimit % 1000);
      console.log("new limit", newLimit);
      newLimit = newLimit - (newLimit % 1000);
      newLimit = Math.round(newLimit);
      console.log("new limit", newLimit);
      if (newLimit < 1000) {
        newLimit = 1000;
      } else if (newLimit > 50000) {
        newLimit = 50000;
      }
      return stats.creditLimit = newLimit;
    };
    businessObject.doesPassFinancialCheck = function() {
      var stats;
      stats = businessObject.stats;
      if (stats.cash > 0 - stats.creditLimit) {
        return true;
      } else {
        return false;
      }
    };
    businessObject.setSprintModifiers = function(sprintNUmber) {
      if (sprintNUmber > 3) {

      } else {

      }
      if (sprintNUmber > 6) {

      } else {

      }
    };
    businessObject.assessBusinessState = function() {
      var flags, stats;
      stats = businessObject.stats;
      flags = businessObject.flags;
      if (stats.cash > 0) {
        flags.cashOnHandIsPositive = true;
      } else {
        flags.cashOnHandIsPositive = false;
      }
      if (stats.cash + stats.creditLimit > 0) {
        flags.doesHaveAvailableFunds = true;
        flags.isBroke = false;
      } else {
        flags.doesHaveAvailableFunds = false;
        flags.isBroke = true;
      }
      if (stats.equity > 0) {
        flags.doesHaveAvailableEquity = true;
      } else {
        flags.doesHaveAvailableEquity = false;
      }
      if (stats.equity > 50) {
        flags.playerHasMajorityEquity = true;
      } else {
        flags.playerHasMajorityEquity = false;
      }
      if (stats.equity >= 100) {
        flags.playerHasTotalOwnership = true;
      } else {
        flags.playerHasTotalOwnership = false;
      }
      if (stats.cash > 1000000) {
        flags.hasPassedHighThreshold_Cash = true;
      } else {
        flags.hasPassedHighThreshold_Cash = false;
      }
      if (stats.research > 100) {
        ({
          hasPassedHighThreshold_Research: true
        });
      }
      if (stats.development > 100) {
        ({
          hasPassedHighThreshold_Development: true
        });
      }
      if (stats.design > 100) {
        ({
          hasPassedHighThreshold_Design: true
        });
      }
      if (stats.marketing > 100) {
        ({
          hasPassedHighThreshold_Marketing: true
        });
      }
      if (stats.sales > 100) {
        ({
          hasPassedHighThreshold_Sales: true
        });
      }
      if (stats.fundraising > 100) {
        ({
          hasPassedHighThreshold_Fundraising: true
        });
      }
      if (stats.potentialMarketSize > 100000) {
        return {
          hasPassedHighThreshold_MarketSize: true
        };
      }
    };
    businessObject.predictBusinessValue = function() {
      var developmentModifier, marketingModifier, newValue, researchModifier, stats;
      newValue = 0;
      stats = businessObject.stats;
      console.log("Current Stats:");
      console.log("average demand:", stats.averageDemand);
      console.log("fixed costs:", stats.fixedCostPerDay);
      console.log("variable costs:", stats.variableCostPerDay);
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
