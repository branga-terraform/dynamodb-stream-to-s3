import boto3
import json

def handler(event,context):
 client = boto3.client('firehose')
 listOfStreams = client.list_delivery_streams()
 print ("List of Streams --> "+",".join(listOfStreams.get('DeliveryStreamNames')))
 for record in event.get('Records'):
    if (record.get('eventName')=='REMOVE'):
        print ("EventID:"+record.get('eventID'))
        print ("EventName:"+record.get('eventName'))    
        print ("Data:"+json.dumps(record.get('dynamodb')))
        dynamodb  = record.get('dynamodb')
        data = dynamodb.get('Keys')
        response = client.put_record(DeliveryStreamName='mft-kinesis-firehose-test-stream', Record= { 'Data' : json.dumps(data) } )
        print ("Response Firehose -->"+response.get('RecordId'))
 print ("Pushed to Kinesis Completed")