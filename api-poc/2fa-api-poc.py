from flask import Flask
from flask_restful import Resource, Api,reqparse
import pyotp

app = Flask(__name__)
api = Api(app)

###################################################################################
# Here we hard-coded a dictionary with user ID and its related secret code 
# to simulate the client system API response
###################################################################################

customerIDSecretCode = {'alice': 'VPPRAX5ZS3EAT3ID', \
                         'bob' : 'O73Y5FPODOZXHJ4G', \
                         'joe' : '6VG5WWIDWHLR3SYE'}

class GACheckPin(Resource):
    def get(self):
        parser = reqparse.RequestParser()
        parser.add_argument('pin', type=str)
        parser.add_argument('customerid', type=str)
        args = parser.parse_args()
        totp = pyotp.TOTP(self.getCustomerIDSecretCode(args['customerid']))
        return {'result': totp.verify(args['pin'], valid_window=3)}
    
    def getCustomerIDSecretCode(self, _customerid):
        return customerIDSecretCode[_customerid]

api.add_resource(GACheckPin, '/')

if __name__ == '__main__':
    app.run(debug=True, port=80, host='0.0.0.0')
