
import json
import sys

print('Number of arguments:', len(sys.argv), 'arguments.')
print('Argument List:', str(sys.argv))

neurons = 100
maxlinks = 15
minlinks = 2
data = {}
data['nodes'] = []
data['links'] = []

for x in range(neurons):
    data['nodes'].append({
        'x': x*40 % 800,
        'y': (int(x*40/800))*40,
        'id': x
    })

for x in range(neurons-1):
    data['links'].append({
        'from': x,
        'to': x+1,
    })

with open('data.json', 'w') as outfile:
    json.dump(data, outfile)
