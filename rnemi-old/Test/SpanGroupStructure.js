SpanGroup = {
    
    "beatIndex": // INT,
    "beats": // INT,
    "subdivision": // INT,
    "tempo": // FLOAT,
    "spans" = [
        {
            "type": "event",
            "beats": // INT
            "subdivision": // INT,
            "beats_adj": // INT,
            "subd_adj": // INT,
            "subdLevel_adj": // INT,
            "components": [
                {
                    "performerID": // STRING: "FL", "CL", "VA"
                    "instrumentID": // STRING, "concert", "Bflat", "viola",
                    "graphID": // STRING, "sounding", "fingered", "tablature", "diagram"
                    
                    // .graphID === "sounding" || "fingered"
                    "info": {
                        "midi": {
                            "type": 
                        },
                        "midi": {

                        },
                        "midi": {

                        }
                    }

                    // .graphID === "tablature"
                    "info": {

                    }

                    // .graphID === "diagram"
                    "info": {

                    }`
                }
            ]
        }
    ]
}