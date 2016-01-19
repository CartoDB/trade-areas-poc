#!//usr/bin/env python

import json
import urllib


# Client for here routing api
class HereRoutingApi:

    # Customer Integration Testing (cit) base URL
    DEFAULT_BASE_URL = 'route.cit.api.here.com'

    # Production base URL
    #DEFAULT_BASE_URL = 'route.api.here.com'

    DEFAULT_PROTOCOL = 'https'

    PATH = '/routing/7.2/'

    RANGE_TYPE_DISTANCE = 'distance'
    RANGE_TYPE_TIME = 'time'


    def __init__(self, app_id, app_code, base_url=DEFAULT_BASE_URL, protocol=DEFAULT_PROTOCOL):
        self.app_id = app_id
        self.app_code = app_code
        self.base_url = base_url
        self.protocol = protocol

    def calculate_isodistance(self, start, destination, mode, distance):
        if (start is None) and (destination is None):
            raise StandarError('both start and destination cannot be None')
        if (start is not None) and (destination is not None):
            raise StandarError('both start and destination cannot be set in the same request')

        request_params = {
            'app_id': self.app_id,
            'app_code': self.app_code,
            'rangetype': self.RANGE_TYPE_DISTANCE,
            'mode': mode,
            'range': distance
        }

        if start is not None:
            request_params['start'] = start
        else:
            request_params['destination'] = destination

        # build the URL
        resource = 'calculateisoline.json'
        url = self.protocol + '://isoline.' + self.base_url + self.PATH + resource

        encoded_request_params = urllib.urlencode(request_params)
        full_url = url + '?' + encoded_request_params
        print full_url
        #response = json.load(urllib.urlopen(full_url))
        response = {}

        return response


# Small script to test the code above
if __name__ == '__main__':
    with open('config.json') as config_file:
        config = json.load(config_file)
    app_id = config['app_id']
    app_code = config['app_code']

    client = HereRoutingApi(app_id, app_code)

    start = 'geo!52.51578,13.37749'
    mode = 'shortest;car;traffic:disabled'
    resp = client.calculate_isodistance(start, None, mode, [1000])

    # pretty-print response
    print json.dumps(resp, indent=4, separators=(',', ': '))
