All database-related files in the app is stored here

### `data.sqlite`

This file holds information about exercises and user statistics. It will be copied to the app document directory (different depend on the OS) on the first time running the app.

### `data.test.sqlite`

Similar to `data.sqlite`, the only different is this database is used in debug mode and is populated with predefined user data for testing purpose.

### `exercises.json`

All official exercises in json format before converted to sqlite. See [`scripts/create_db.py`](/scripts/create_db.py).

### `exercises.input.json`
Exercises info from the [Gym Workout] app. It will be converted to the GymLab-compatible json file (`exercises.json`)

### `exercises.sample.json`
A sample json file to note the different in data structure between [Gym Workout] json data and GymLab-compatible one.

### `exercises.custom.json`
List of custom exercises of GymLab. This is the only way to add custom exercises for the app. I don't have plan to support adding custom exercises for GymLab because the mobile interface is kind of clunky to do this kind of job.

### `favorites.json`
Predefined user data about favorite exercises. Only populated in debug mode.


[Gym Workout]: https://play.google.com/store/apps/details?id=com.fitness22.workout&hl=en
