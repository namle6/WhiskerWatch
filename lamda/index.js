const {RekognitionClient, DetectLabelsCommand} = require("@aws-sdk/client-rekognition");
const twilio = require('twilio')

const rekognitionClient = new RekognitionClient()
const CONFIDENCE_THRESHOLD = 65

exports.handler = async (event) => {
    try {
        const bucket = event.Records[0].s3.bucket.name
        const key = decodeURIComponent(event.Records[0].s3.object.key.replace(/\+/g, ' '))

        const detectLabelsCommand = new DetectLabelsCommand({
            Image: {
                S3Object:{
                    Bucket: bucket,
                    Name: key
                }
            },
            MinConfidence: CONFIDENCE_THRESHOLD
        })

        const rekognitionResponse = await rekognitionClient.send(detectLabelsCommand)
        console.log("Rekognition Response:", JSON.stringify(rekognitionResponse, null, 2))

        const needsRefill = checkIfNeedsRefill(rekognitionResponse.Labels)

        if (needsRefill){
            const twilioClient = twilio(
                process.env.TWILIO_ACCOUNT_SID,
                process.env.TWILIO_AUTH_TOKEN
            )

            
            await twilioClient.calls.create({
                twiml: `<Response><Say>Alert! Cat beans are running low  Time to reorder beans.</Say></Response>`,
                to: process.env.TWILIO_PHONE_TO,
                from: process.env.TWILIO_PHONE_FROM
            })
            
        }

        return {
            statusCode: 200,
            body: JSON.stringify({
                message: 'Image processed successfully',
                needsRefill: needsRefill
            })
        }

    } catch (error) {
        console.error('Error:', error)
        throw error
    }
}

function checkIfNeedsRefill(labels) {
    const relevantLabels = ['Bean', 'Coffee']

    const hasRelevantLabels = labels.some(
        label => relevantLabels.includes(label.Name) && label.Confidence >= CONFIDENCE_THRESHOLD
    )

    return !hasRelevantLabels
}