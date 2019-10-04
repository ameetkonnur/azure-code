const http = require('https');
queryString = require('querystring');

// prepare AAD API Post Body Data
var postData = queryString.stringify({
    'grant_type': 'client_credentials',
    'client_id': 'e9858ba0-f9c2-4046-b5a0-6446f32fe35f',
    'resource':'https://api.loganalytics.io/',
    'client_secret':'3b105647-2b94-4cb7-9c0b-641f6f5e397b'
});

console.log(postData);
var contentLength = postData.length;

// prepare for calling AAD Token API
var options = {
    host: 'login.microsoftonline.com',
    port: 443,
    path: '/72f988bf-86f1-41af-91ab-2d7cd011db47/oauth2/token',
    method: 'POST',
    headers: {
        'Content-Type' : 'application/x-www-form-urlencoded',
        'Content-Length': postData.length
    },
};

    var postTokenRequest = http.request(options,function(res){
    res.on('data',function(chunk){
        
        // get token from AAD Token Request call
        token = JSON.parse(chunk);

        // prepare for calling Log Analytics Query Execution
        options = {
            host : 'api.loganalytics.io',
            port: 443,
            method: 'POST',
            path: '/v1/workspaces/80a65063-8611-4b2f-8105-c8501f847eb7/query',
            headers: {
                'Authorization': 'Bearer ' + token['access_token'],
                'Content-Type' : 'application/json'
            }
        };
        
        var data = '';

        // call Log Analytics API
        var postDataRequest = http.request(options,function(res){
            console.log('STATUS: ' + res.statusCode);

            // get Query Response
            res.on('data',function(chunk){
                data += chunk;
            });

            // on end of Response Parse JSON and display no of records
            res.on('end',function(){
                if (res.statusCode == 200)
                {
                    //console.log(data.length);
                    data = JSON.parse(data);

                    // print no of records received by log analytics
                    console.log('No of Rows from API : ' + data.tables[0].rows.length);

                    // insert data into mysql
                    var mysql = require('mysql');

                    // open mysql connection
                    var con = mysql.createConnection({
                        host: "mysqlsvr01.mysql.database.azure.com",
                        user: "scott@mysqlsvr01",
                        password: "@zure12345678",
                        database: "billingdb"
                    });
                    con.connect(function(err){
                        if (err) throw err;
                        values = [];
                        jsonData = data.tables[0].rows;

                        // create array for bulk insert
                        for (i=0; i < jsonData.length; i++)
                        {
                            values.push([jsonData[i][0],jsonData[i][1],jsonData[i][2],jsonData[i][3],jsonData[i][4],jsonData[i][5],jsonData[i][6],jsonData[i][7],jsonData[i][8],jsonData[i][9],jsonData[i][10],jsonData[i][11],jsonData[i][12],jsonData[i][13],jsonData[i][14],jsonData[i][15],jsonData[i][16],jsonData[i][17],jsonData[i][18],jsonData[i][19],jsonData[i][20],jsonData[i][21],jsonData[i][22],jsonData[i][23],jsonData[i][24],jsonData[i][25],jsonData[i][26],jsonData[i][27],jsonData[i][28],jsonData[i][29]])   
                        }
                        
                        // do bulk insert
                        var sql = 'INSERT INTO heartbeat (TenantId,SourceSystem,TimeGenerated,MG,ManagementGroupName,SourceComputerId,ComputerIP,Computer,Category,OSType,OSName,OSMajorVersion,OSMinorVersion,Version,SCAgentChannel,IsGatewayInstalled,RemoteIPLongitude,RemoteIPLatitude,RemoteIPCountry,SubscriptionId,ResourceGroup,ResourceProvider,Resource,ResourceId,ResourceType,ComputerEnvironment,Solutions,VMUUID,Type,_ResourceId) VALUES ?'
                        con.query(sql ,[values],function(err,_result){
                            if (err) throw err;
                            console.log('Rows Inserted into Database : ' + _result.affectedRows);
                            con.end();
                        });
                    });                    
                }
            });
        });
        
        // get last end date time from azure table storage
        // TBD

        // calculate new start & end date time
        var startDate = new Date();
        var endDate = new Date();
        startDate.setMinutes(startDate.getMinutes() - 15);
        
        // end date is always NOW - 5 minutes accomodating log analytics delay
        endDate.setMinutes(endDate.getMinutes() - 10);

        // form the log analytics query
        
        var query = '{"query" : "Heartbeat | where TimeGenerated between (todatetime(\\"' + startDate.toISOString() + '\\") .. todatetime(\\"' + endDate.toISOString() + '\\"))"}'
        
        console.log(query);

        // post the query data to the log analytics API
        postDataRequest.write(query);
        postDataRequest.end();
    });
});

postTokenRequest.write(postData);
postTokenRequest.end();