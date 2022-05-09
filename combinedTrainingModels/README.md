## Models trained with all of the Hyalite data & the training split of the Teton data

Below are the results from three models (neural net, RUSBoost, and AdaBoost), after they were trained on all the Hyalite data and the training split of the Teton data. The source code is on the `hannahCombinedTraining` branch.

### Results

#### Neural Net

- row results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 42335         | 204           |
| insect        | 3             | 0             |

`Accuracy:` 0.9951
`Precision:` 0
`Recall:` 0

- image results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 119           | 117           |
| insect        | 1             | 2             |

`Accuracy:` 0.5063
`Precision:` 0.0168
`Recall:` 0.6667

#### RUSBoost


- row results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 42393         | 146           |
| insect        | 3             | 0             |

`Accuracy:` 0.9965
`Precision:` 0
`Recall:` 0

- image results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 141           | 95            |
| insect        | 0             | 3             |

`Accuracy:` 0.6025
`Precision:` 0.0306
`Recall:` 1

#### AdaBoost


- row results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 42538         | 1             |
| insect        | 3             | 0             |

`Accuracy:` 0.9999
`Precision:` 0
`Recall:` 0

- image results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 236           | 0             |
| insect        | 2             | 1             |

`Accuracy:` 0.9916
`Precision:` 1
`Recall:` 0.3333
