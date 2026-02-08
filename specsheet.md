
# Rules for implementation
This sheet represents a complete list of specifications for all pages on the requested app. Always utilize SwiftUI best practices, and consult documentation when you are unclear about the best way to go about doing something.

Whenever you are confused about the functionality of a feature, utilize PlayWright to view the webpage equivilant. It is hosted at localhost:3000 - you can login using my credentials with username: petergelgor7@gmail.com, password: password.

Before considering anything finished, you MUST make use of the Simulator with the XcodeBuildMCP tooling provided.

If you need help on any of the wiring, consult the original website code. It exists at /Users/petergelgor/Documents/projects/budgeting_app/frontend, and /Users/petergelgor/Documents/projects/budgeting_app/backend. You can see the docker setup at /Users/petergelgor/Documents/projects/budgeting_app/

# Login
### First initialization
- Users will host their own instance of the backend using the docker service contained here. We may need to expose the backend port as a standalone in the docker, as right now only the frontend is exposed.
- Users should be prompted to enter the URL of their running instance's backend.
- Upon successful connection to a running backend, users should be relocated to the login screen

### After connected to backend
- Users can login to an existing account, or sign up for a new account using the same flow found in [AuthPages.tsx](frontend/src/features/auth/AuthPages.tsx)

### Layout
- Keep the layout of the page the same as it is on web, just formatted for mobile.


## Shared features across all pages

### Navigation bar
- A navigation menu should be present at all times in the app, allowing users to open a nav menu where they can switch pages seamlessly. This menu should be a single button that when pressed, expands into the whole screen, presenting the possible locations the user can browse to.

- This menu should be present at the bottom center of the page, and expand to fill the user's screen. It should be represented as circle with an up arrow, and when clicked switch to a down arrow.

- When the menu is expanded and the menu button changes to a down arrow, when it is clicked, the nav menu should animate back into the button, leaving the user where they were prior to opening the page.

- When the menu is expanded, and the user clicks a new location, the same animation should play - the menu animates back into the button (shrinking from a full page down to the circle at the bottom center of the screen), this time leaving the screen at the new page requested by the user.

- This menu should contain the following links:
    - Connections
    - Transactions
    - Categories
    - Budgets
    - Recurring

### Home bar
- With the navigation menu set in the middle bottom of the screen, to the left of the nav menu should be a "Home" button, bringing users to the Dashboard.
- To the right of the navigation menu, should be a "Settings" button, allowing users to access their user settings, including logging out and configuring their backend connection.
- The "Dashboard" and "Settings" buttons should be slightly smaller than the "Nav" menu button.
- The home bar should look very similar to the Instagram navigation bar at the bottom - use iOS default Nav APIs for this.


# Pages
## Dashboard (main page)
### Income vs Spending
- At the top of the page, should be a graph titled "Income vs Spending". 
- This represents monthly income vs spending totals. 
- It should be able to be toggled between a bar chart, and a cumulative line chart. Display it identically to how it is displayed in the website now.
- Users should be able to tap on any part of either graph, to see exact numbers for that data point.

### Net Worth Breakdown
- Below the Income vs Spending graphs, should be a section representing the users total net worth.
- This should list all of their connected accounts, separated in two ways.
    - First, accounts will be separated by type - any of "Bank Accounts", "Investments", and "Liabilities".
    - Second, accounts will then be grouped by institution. If the user has multiple account types from the same institution (investments and liabilities for example), there should be two separate sections for that institution. See the website for an example.
- Users should be able to click on any account to access and modify it's properties.
    - Upon clicking an account, they should be met with a page that primairly displays the account name, the institution, the "Net Worth Category" (Bank Accounts, Investments, Liabilities), the currency, the Current Balance, the Last Balance Update, and the Status (active/inactive).
        - Users should be able to modify the Net Worth Category in this page, and nothing else.
    - Below the properties of the account, in the same page, users should be able to see a list of their recent transactions.
    - See the current website for more details on this implementation.
- Below the "Net Worth Breakdown", there should be 5 boxes containing information:
    1. Income for the current month
    2. Expenses for the current month
    3. Savings rate (100 * (1 - (expenses/income)))
    4. Spending by Category:
        - This will be a table with 3 columns: Category, Amount, and %.
        - Each category will have it's own row
        - Amount is amount spent on that category in the current month.
        - % is the percentage that the given category takes up of total spending.
    5. Budget Progress: displays the following information:
        - Targeted Spend: the sum of all the user's budgets
        - Actual Spend: how much the user has spent across all budgets in the current month
        - Overspent Categories: a list of all the categories where the spending in the current month exceeds the user's preset budget.
- Present at the top of the page should be a "gear" icon, enabling users to rearrange the dashboard components, removing ones they don't want, and allowing them to re-add components they've previously removed. 
    - Rearranging should behave similar to re-arranging app icons on the iOS home screen - when one component moves, the rest move to fill in the gap.

## Connections
### Connect Bank via SimpleFIN
- In this box, the user will be able to enter a SimpleFIN Setup Token, gathered through SimpleFIN to connect their accounts.
### Account Snapshot
- This section should display three pieces of information:
    1. Assets: total assets combined across all accounts
    2. Liabilities: Total liabilities combined across all accounts
    3. Net Worth: Assets - Liabilities

### Linked Institutions
- This section will display a table containing all the users linked institutions, across all the SimpleFIN connections they've authorized.
- The table will contain 5 columns:
    1. Institution: The current institution
    2. Status: SUCCESS or FAILURE
    3. Accounts: Number of accounts with that institution
    4. Last Sync: When the last sync to that institution was (the date and time)
    5. Actions: Enable the user to sync that institution, or remove it with two separate buttons, one for each action.
- Ensure that there is exactly one institution per row on that table.

## Transactions
### Filters
- Provide a section at the top for the user to filter transactions by the following criteria:
    1. Start: The earliest transaction date to display (inclusive)
    2. End The latest transaction date to display (inclusive)
    3. Description: Description matching transactions. Case insensitive, ignore special characters and punctuation.
    4. Account: Select account(s) to show, hiding unselected accounts
    5. Category: Filter for a given category
    6. Transfers: Checkbox showing "Include internal transfers" - by default this is off.
- By default, all fields should be empty, showing all transactions loaded by SimpleFIN, with the only exception being "Include internal transfers", which will by default be off - hiding internal transfers. Will elaborate on this soon.

### Imported Transaction Coverage
- Provide a section showing details on the import status of the users transactions
- Show 3 fields:
    1. Total Imported: total transactions imported by SimpleFIN
    2. Oldest Imported: the date of the oldest transaction imported by SimpleFIN
    3. Newest Imported: the date of the newest transaction imported by SimpleFIN

### Unified Transactions
- Show a table representing all transactions.
- At the top of the table, beside the header, should have a dropdown allowing the user to choose the number of transactions to show per page.
    - Set available options as 5, 10, 20, and 50.
    - Default is 10.
- Each row represents a transaction. Have the title for each row be the description. In each row, show the following information
    1. Date: the date of the transaction
    2. Account: the account the transaction was found in
    3. Category: the category the transaction falls in. Have this be modifyable by a dropdown, allowing the user to select any available category from a dropdown list.
    4. Amount: the amount of money spent/recieved in that transaction
    5. Notes: any notes the user has written for that transaction
    6. ID: the ID of the transaciton
    7. A button bringing up extra options:
        - Notes: allow the user to write notes
        - Exclude from totals: a checkbox that if checked, will exclude that transaction from total calculations.
        - Add Rule: Allow the user to make a new rule, using that transaction as a template. Will elaborate on this in the "Categories" section.
        - Mark Transfer: Allow the user to select an equal and opposite transaction (same amount, sign flipped), to represent this transaction as an internal transfer and to exclude it from the totals calculation.
- Rows should be sorted by Date, with an option to sort either descending (newest first), or ascending (oldest first). Default is descending (newest first).
- Next and Previous buttons: allow the user to paginate between transactions, showing the next (or previous) n transactions, with n being set as the table size selected by the user. 

### Transfer Pairs:
- Show a table representing all transfer pairs.
- Similar to the Unified Transactions table, the top of this table should have a dropdown allowing the user to choose the number of transactions to show per page.
    - Same available options of 5, 10, 20, 50
    - Default is 10
- Each row represents a transfer pair. Have the title for each row be the Description. In each row, show the following information:
    1. Date: the date of the first transaction in the pair
    2. From Account: The account that sent the money (balance lost from account)
    3. To Account: The account that recieved the money (balance added to account)
    4. Amount: the nominal value of the transaction
    5. Type: either Auto Detected, or Manual.
    6. ID Pair: Show "From {send_transaction_id} To {recieve_transaction_id}"
    7. Unlink: Button enabling users to unlink the transfer pair, separating them into two separate transactions.
- Rows should be sorted by date, with an option to sort either descending (newest first), or ascending (oldest first). Default is descending (newest first).
- Next and Previous buttons: allow the user to paginate between transactions, showing the next (or previous) n transactions, with n being set as the table size selected by the user. 
- Filters set at the top should apply to both the Unified Transactions table and the Transfer Pairs table.
- Paginating between one table should not paginate between the other.
- Changing the number of transactions per page on one table should not change the transactions per page on the other.
- By default, this table should automatically populate with data. The system should attempt to match all equal and opposite transactions that could represent a transfer pair, so the user doesn't have to do this generally. This system is already in place in the existing website.

## Categories
### Create Category
- Supply the user with a set of fields to create a new category.
- These fields will be as follows:
    1. Name: The name of the new category (textfield)
    2. Type: A dropdown with options "Expense", "Income", or "Transfer".
    3. Parent: Choose a parent category for this new category. Supplied as a dropdown, allowing users to choose any existing category.
        - Default is "No Parent", which if kept, will make this new category a root level category.
- At the bottom of the fields, supply a button called "Create Category", which will save the new category for the user.

### Category Tree
- Display all created categories as a table, with categories indented under their parent if they are not root categories
- For each row, show the following fields:
    1. Name: the name of the category
    2. Type: either "Expense", "Income", or "Transfer"
    3. Edit: A button enabling users to edit the categories fields - provide the same options as appear in the "Create Category" section, just with the fields already filled out with the existing category's information. Allow all of the fields to be editable.
        - Have this show up as a new page - so when a user clicks "Edit", they are immediately brought to a screen where they can edit the category.
        - Allow the user to both confirm, or discard changes in this screen.
    4. Remove: A button enabling users to delete the given category.

### Auto-Categorization Rules:
- At the top, display a button enabling users to create a new rule.
    - When pressed, a new page should appear, letting users fill in the following information:
        1. Rule Name: the name of the rule (textbox)
        2. Assign Category: The category transactions affected by this rule will be moved to (dropdown of all available categories, default "Select Category")
        3. Filter Join: either "All filters must match (AND)" or "Any filter can match (OR)" (dropdown, default AND)
        4. Priority: the priority of the rule. Higher priority means if a transaction matches multiple rules, it will match based on the highest priority rule. (Number textbox, default 0)
        5. Status: Either "Active" or "Inactive" (dropdown, default "Active")
        6. Field filters:
            - Field: Dropdown of either Description, Amount, or Account.
            - Operator: Dropdown of "contains", "starts with", "ends with", or "matches exactly"
            - Value: the value to match (textbox)
        7. Add Filter: A button enabling users to add more filters
        8. Create rule: A button enabling users to confirm their choices for the new rule.

- Below the "New Rule" button, display all existing rules as a table.
    - Each row represents a single rule.
    - In each row, display the following:
        1. Rule Name: the name of the rule.
        2. Filters: List of filters that must match to trigger this rule.
        3. Edit: A button enabling users to edit rules.
            - This should display identically to editing an existing transaction
            - Meaning a new page will pop up, identical to the "Create Rule" page, just with all the existing information of that rule pre-populated
            - Users can either confirm or discard changes, bringing them back to the table of rules.
        4. Delete: A button enabling users to delete rules.
    - Sort this table alphabetically by default.
    - At the top of the table, provide a search bar to filter by rule name.

## Budgets
### Monthly Targets
- A table displaying the users monthly targets for each category.
- Each row represents a category.
- Display the following columns:
    1. Category: the name of the category (non editable)
    2. Target: Budgeted amount for this target (number field)
    3. Actual: How much the user has spent this month on that target (not editable)
    4. Variance: Actual - Target (not editable)
    5. Notes: textfield allowing user to write notes
    6. Clear: A button allowing users to clear all fields for that category (target and notes)
- When a user modifies information here, it should automatically save.

### Budget vs Actual
- A read-only table displaying how much the user has spent for each category, showing the following fields
    1. Category: The name of the category
    2. Target: How much the user has budgeted for the category
    3. Actual: How much the user has spent in that category this month
    4. Variance: Target - Actual
    5. Status: Over/Under

### Uncategorized Spending Warning
- Display a list of all the transactions this month that are not categorized.
- Allow users to categorize them from this screen.
- Also allow users to add rules or mark transfers based on this transaction.
    - Should behave identically to the "Unified Transactions" table on the "Transactions" page.

## Recurring Bills
### Recurring Patterns
- Show a table of all recurring transactions as detected by the system.
- Table should show the following columns:
    1. Name: the name of the recurring transaction
    2. Amount: The amount of the recurring transaction
    3. Frequency: one of Daily, Weekly, BiWeekly, Monthly, BiMonthly, Yearly, BiYearly (use existing options from the website)
    4. Next Expected: When this transaction is expected to take place next
    5. Category: the category this transaction falls in
    6. Delete: A button allowing users to remove this transaction from this table.

### Upcoming Bills
- Show a table of all upcoming bills the user has, as identified by the Recurring Patterns table.
- Table should show the following columns:
    1. Name: The name of the transaction
    2. Amount: the amount to be spent for the upcoming transaction
    3. Due Date: the date of the expected transaction
    4. Days until due: number of days until the expected transaction
    5. Category: The category the expected transaction will fall in


## Settings
- Allow the user to modify their connection to their backend server
- Also allow the user to sign out of their account
- Enable the user to toggle between dark and light mode.

