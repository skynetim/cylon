# Display Image from Camera

First, let's import Cylon:       

    Cylon = require('../..')

Now that we have Cylon imported, we can start defining our robot

    Cylon.robot

Let's define the connections and devices:

      connection:
        name: 'opencv', adaptor: 'opencv'

      devices: [
        { name: 'window', driver: 'window' }
        { name: 'camera', driver: 'camera', camera: 0 }
      ]

Now that Cylon knows about the necessary hardware we're going to be using, we'll
tell it what work we want to do:

      work: (my) ->
        my.camera.on('cameraReady', ->
          console.log('THE CAMERA IS READY!')
          my.camera.on('frameReady', (err, im) ->
            my.window.show(im, 5000)
          )
          my.camera.readFrame()
        )

Now that our robot knows what work to do, and the work it will be doing that
hardware with, we can start it:

    .start()
