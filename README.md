This is a client PoC to get "isodistances" from Here Routing API.

The `cdb_geocoder_server` (probably to be renamed to `cdb_dataservices_server` or something on the line) will have to adapt the responses from Here from json to postgis.


The example in here-client.py is pretty similar to the one in the [here quickstart guide](https://developer.here.com/rest-apis/documentation/routing/topics/request-isoline.html), but using several comma-separated values for the `range` parameter

It requires a `config.json` file to run with valid credentials. See `config.json.example`.

One example of its output (shapes truncated for brevity):
```json
{
    "response": {
        "start": {
            "linkId": "+1089845810",
            "originalPosition": {
                "latitude": 52.51578,
                "longitude": 13.37749
            },
            "mappedPosition": {
                "latitude": 52.5157795,
                "longitude": 13.3774881
            }
        },
        "isoline": [
            {
                "range": 1000,
                "component": [
                    {
                        "shape": [
                            "52.5160217,13.3635807",
                            "52.5160217,13.3683014",
                            "52.5161934,13.3688164",
                            "...",
                            "52.5160217,13.3635807"
                        ],
                        "id": 0
                    }
                ]
            },
            {
                "range": 2000,
                "component": [
                    {
                        "shape": [
                            "52.5155067,13.3496761",
                            "52.5158501,13.3499336",
                            "52.5160217,13.3504486",
                            "...",
                            "52.5155067,13.3496761"
                        ],
                        "id": 0
                    }
                ]
            },
            {
                "range": 3000,
                "component": [
                    {
                        "shape": [
                            "52.5141335,13.3352566",
                            "52.5144768,13.3355141",
                            "52.5158501,13.3368874",
                            "...",
                            "52.5141335,13.3352566"
                        ],
                        "id": 0
                    }
                ]
            }
        ],
        "center": {
            "latitude": 52.51578,
            "longitude": 13.37749
        },
        "metaInfo": {
            "timestamp": "2016-01-19T17:11:13Z",
            "interfaceVersion": "2.6.15",
            "mapVersion": "8.30.59.107",
            "moduleVersion": "7.2.61.0-1206"
        }
    }
}
```
