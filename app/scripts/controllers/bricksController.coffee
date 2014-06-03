app = angular.module("geniusApp")

class BricksCtrl extends BaseCtrl

  @register app, 'BricksCtrl'
  @inject "$scope", "$rootScope", "$timeout", "Brick", "dropService", "simulationService"

  initialize: ->
    @$scope.gates =
      [
        { type: 'AND' },
        { type: 'OR' },
        { type: 'NOT' },
        { type: 'INPUT' },
        { type: 'OUTPUT' }
      ]

    @$scope.private = []

    @$scope.public = []

    @$scope.chartConfig =
      options:
        chart:
          type: "spline"

      title: "Simulation"

      xAxis:
        labels:
          enabled: false

      loading: true

      credits:
        enabled: false

    @$scope.run = =>
      @Brick.all().done (bricks) =>

        solution = @simulationService.run(bricks)

        data = numeric.transpose(solution.y)

        console.log data

        @$scope.chartConfig.series = [
          {
            name: "S"
            data: data[0]
            id: "series-0"
          },
          {
            name: "E"
            data: data[1]
            id: "series-1"
          },
          {
            name: "C"
            data: data[2]
            id: "series-2"
          },
          {
            name: "P"
            data: data[3]
            id: "series-3"
          }
        ]

        @$scope.chartConfig.loading = false

    @$scope.loadStoredBricks = =>      
      @$rootScope.$on 'ngRepeatFinished', (ngRepeatFinishedEvent) =>
        @Brick.all().done (bricks) =>
          for brick in bricks
            ui =
              draggable: $('.bricks-container div.brick.' + brick.brick_type)
              position:
                left: brick.left
                top: brick.top
            
            @dropService.drop(brick.id, @$rootScope, ui, false)

            unless typeof brick.connections is 'undefined'
              for connection in brick.connections
                jsPlumb.connect({ source: "brick-" + brick.id, target: "brick-" + connection }, @$rootScope.sourceEndPoint)

    @$scope.collapse =
      gates: false
      private: false
      public: false

    @$scope.filter = (type) =>
      @$scope.collapse[type] = not @$scope.collapse[type]

    @$scope.new = =>
      # new brick

    @$scope.copy = =>
      # copy brick

    @$scope.export = =>
      # export brick
