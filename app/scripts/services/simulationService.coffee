app = angular.module("geniusApp")

app.factory "simulationService", ($compile, $rootScope) ->

  TF1 = 42
  TF2 = 7
  k1 = 4.7313
  gene1_k2 = 4.6337
  gene1_d1 = 0.0240
  gene1_d2 = 0.8466
  gene2_k2 = 4.6337
  gene2_d1 = 0.0205
  gene2_d2 = 0.8627
  Km = 224.0227
  n = 1

  mRNA = 0
  Protein = 0

  run: (bricks) ->
    for brick in bricks
      if brick.brick_type is 'brick-input'

        f = (t, x) ->
          i = 0

          equations = []

          addEquations = (connections) ->
            if connections?
              for connection in connections
                connectedBrick = bricks.filter((item) ->
                  item.id is connection.target
                )[0]

                if i is 0
                  input = TF1
                else if !x[i-1]?
                  input = 0
                else
                  input = x[i-1]

                x[i] ||= 0
                x[i+1] ||= 0

                if connectedBrick.brick_type is 'brick-not'
                    equations.push( ( k1 * Km^n ) / ( Km^n + input^n ) - gene1_d1 * x[i] )
                    equations.push( gene1_k2 * x[i] - gene1_d2 * x[i+1] )

                else if connectedBrick.brick_type is 'brick-and'
                  if i is 0
                    equations.push( ( k1 * (TF1 * TF2)^n ) / ( Km^n + (TF1 * TF2)^n ) - gene1_d1 * x[i] )
                    equations.push( gene2_k2 * x[i] - gene2_d2 * x[i+1] )

                  else if x[i-1] is 0
                    x[i] = 0
                    x[i+1] = 0

                    equations.push( ( k1 * (TF1 * TF2)^n ) / ( Km^n + (TF1 * TF2)^n ) - gene1_d1 * x[i] )
                    equations.push( gene2_k2 * x[i-1] - gene2_d2 * x[i+1] )

                  else
                    # Todo
                    equations.push( ( k1 * Km^n ) / ( Km^n + x[i-1]^n ) - gene2_d1 * x[i] )
                    equations.push( gene2_k2 * x[i] - gene2_d2 * x[i+1] )

                i += 2

                addEquations(connectedBrick.connections)

          addEquations(brick.connections)

          equations

        if brick.connections?
          # TODO: brick.connections.length * 2 is wrong formula
          startValues = Array.apply(null, new Array(brick.connections.length * 2)).map(Number.prototype.valueOf,0)

          sol = numeric.dopri(0, 20, startValues, f, 1e-6, 2000)

          return sol
