*** Settings ***
Documentation       Orders robots from RobotSpareBin Indrustries INC
...                 Save the order HTML receipt as a PDF file.
...                 Saves the screenchot of the ordered robot.
...                 Embeds the screenshot of the robot to the PDF receipt.
...                 Creates ZIP archive of the receipts and the images.
Library            RPA.Browser.Selenium    auto_close=${False}
Library            RPA.Tables
Library            RPA.HTTP
Library            RPA.PDF
Library            RPA.Archive

*** Variables ***
${zipPath} =     C:\\Users\\BG435YX\\OneDrive - EY\\Documents\\ROBOCORP\\Curso nivel 2\\Robot1\\ImgAndResult


*** Tasks ***
Orders robots from RobotSpareBin Indrustries INC
    Open website order Robot
    Download the CSV file
    Lectura de CSV
    ZipGenerate

*** Keywords ***
Open website order Robot
    Open Available Browser    https://robotsparebinindustries.com/#/robot-order
    Click Button    OK

Download the CSV file
   Download    https://robotsparebinindustries.com/orders.csv    overwrite=True

Insertar datos
    [Arguments]    ${order_robot}
    Select From List By Value    head    ${order_robot}[Head]
    Select Radio Button    body   ${order_robot}[Body]
    Select From List By Value     1677514499096   ${order_robot}[Legs]
    Input Text    address    ${order_robot}[Address]
    Click Button    Preview
    Screenshot    robot-preview-image    ${zipPath}${/}${order_robot}[Address].png
    Click Button    Order

    Wait Until Element Is Visible    id:receipt
    ${receipt_html}=    Get Element Attribute    id:receipt   outerHTML
    Html To Pdf    ${receipt_html}    ${zipPath}${/}${order_robot}[Address].png
    Click Button    Order another robot
    Click Button    OK


Lectura de CSV
    ${order_robot}=    Read table from CSV    C:\\Users\\BG435YX\\OneDrive - EY\\Documents\\ROBOCORP\\Curso nivel 2\\Robot1\\orders.csv
    FOR    ${order_robot}    IN    @{order_robot}
        Insertar datos    ${order_robot}
    END

ZipGenerate
    Archive Folder With Zip    ${zipPath}    NewZip.zip