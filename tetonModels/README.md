### Teton Only Models

Below are the results from three models (neural net, RUSBoost, and AdaBoost), after they were trained on only the Teton data from August 13th, 2020. The source code is on the `hannahTetonOnly` branch.

#### Results


#### Neural Net

- row results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 42518         | 21            |
| insect        | 3             | 0             |

`Accuracy:` 0.9994
`Precision:` 0
`Recall:` 0

- image results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 217           | 19            |
| insect        | 2             | 1             |

`Accuracy:` 0.9121
`Precision:` 0.0500
`Recall:` 0.3333

#### RUSBoost


- row results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 32762         | 9777          |
| insect        | 2             | 1             |

`Accuracy:` 0.7701
`Precision:` 0.0001
`Recall:` 0.3333

- image results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 4             | 232           |
| insect        | 0             | 3             |

`Accuracy:` 0.0293
`Precision:` 0.0128
`Recall:` 1

#### AdaBoost


- row results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 42435         | 104           |
| insect        | 3             | 0             |

`Accuracy:` 0.9975
`Precision:` 0
`Recall:` 0

- image results (true class is vertical & predicted class is horizontal)

|               | non-insect    | insect        |
| ------------- | ------------- | ------------- |
| non-insect    | 195           | 41            |
| insect        | 2             | 1             |

`Accuracy:` 0.8201
`Precision:` 0.0238
`Recall:` 0.3333
