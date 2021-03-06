Cylon = require('../..')

Cylon.robot
  connection:
    name: 'opencv', adaptor: 'opencv'

  devices: [
    { name: 'window', driver: 'window' }
    {
      name: 'camera',
      driver: 'camera',
      camera: 0,
      haarcascade: "#{ __dirname }/haarcascade_frontalface_alt.xml"
    } # Default camera is 0
  ]

  work: (my) ->
    # We setup our face detection when the camera is ready to
    # display images, we use `once` instead of `on` to make sure
    # other event listeners are only registered once.
    my.camera.once('cameraReady', ->
      console.log('The camera is ready!')
      # We add a listener for the facesDetected event
      # here, we will get (err, image/frame, faces) params back in
      # the listener function that we pass.
      # The faces param is an array conaining any face detected
      # in the frame (im).
      my.camera.on('facesDetected', (err, im, faces) ->
        # We loop through the faces and manipulate the image
        # to display a square in the coordinates for the detected
        # faces.
        for face in faces
          im.rectangle([face.x, face.y], [face.x + face.width, face.y + face.height], [0,255,0], 2)
        # The second to last param is the color of the rectangle
        # as an rgb array e.g. [r,g,b].
        # Once the image has been updated with rectangles around
        # the faces detected, we display it in our window.
        my.window.show(im, 40)

        # After displaying the updated image we trigger another
        # frame read to ensure the fastest processing possible.
        # We could also use an interval to try and get a set
        # amount of processed frames per second, see below.
        my.camera.readFrame()
      )
      # We listen for frameReady event, when triggered
      # we start the face detection passing the frame
      # that we just got from the camera feed.
      my.camera.on('frameReady', (err, im) ->
        my.camera.detectFaces(im)
      )

      # Here we could also try to get a set amount of processed FPS
      # by setting an interval and reading frames every set amount
      # of time. We could just uncomment the next line, then comment
      # out the my.camera.readFrame() in the facesDetected listener
      # above, as well as the one two lines below.
      #every 150, my.camera.readFrame
      my.camera.readFrame()
    )
.start()
