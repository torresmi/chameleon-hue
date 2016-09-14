module Resource.Configuration exposing (..)

-- Create User


createUserSuccess : String
createUserSuccess =
    """
    [{"success":{"username": "83b7780291a6ceffbe0bd049104df"}}]
    """


createUserLinkFailure : String
createUserLinkFailure =
    """
    [
        {
            "error": {
                "type": 101,
                "address": "",
                "description": "link button not pressed"
                }
            }
    ]
    """



-- Delete user


deleteUserSuccess : String
deleteUserSuccess =
    """
    [{"success": "/config/whitelist/1234567890 deleted."}]
    """


deleteUserFailure : String
deleteUserFailure =
    """
    [
        {
            "error": {
                "type": 901,
                "address": "",
                "description": "Generic error"
                }
        }
    ]
    """
