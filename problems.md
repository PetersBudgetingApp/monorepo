# Problems with this app

## Dashboard
### Income vs Spending
#### Bar chart
- When I click on a month, it shows the next month's data - so clicking "Dec" shows "January" data.

#### Cumulative line
- The line shows up as a single line, not two lines. This causes it to look like a "sawtooth", as both income and expenses are put as datapoints on the same line.
- I want one line for income, and one line for expenses. 


## Transactions
- Sort doesn't work - flipping from newest to oldest just doesn't do anything
- Please move "Import Coverage" above the "Filters" section. 
    - It should be below the "Transactions" label, above the table size selector.

## Categories
- Present: Can only edit custom categories
- Should be able to edit/delete all categories, whether it was made by the system or not
- Do not display that it was made by the system.

### Editing Category Rules
- Filter Join section has too much text per section. Text is getting cut off.
- Change it to just "AND"/"OR".

## Budgets
### Monthly Targets
- Categories don't have enough space - will need to reorganize this such that all text is visible. Right now categories are getting cut off, and Variance is being pushed into two lines.

### Budget vs Actual
- Category doesn't have enough space at all - it just displays as 3 dots (...). Please reorganize this such that categories are displayed properly.
- Total at the bottom is being pushed to one character per line (so each of "T", "o", "t", "a", "l", are all on separate lines due to margins) - please fix this.

## Recurring
### Recurring Patterns
- Please remove column names. They aren't helpful, and not even accurate.
- Just have it as the list of recurring patterns, no "Name", "Amount", "Frequency" values.

## General
- You have everything listed as USD, when I use CAD for all my accounts. Please go based on the currency value displayed in the "Account Details" section when you click on an account from the "Bank Accounts" section inside the Dashboard page.
- Please implement FaceID login for the future