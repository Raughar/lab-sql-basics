-- Selecting the database to work with:
select bank;

-- Getting the id values of the first 5 clients with a value of 1:
select client_id
from client
where district_id = 1
limit 5;

-- Getting the last client whose district_id equals 72
select client_id
from client
where district_id = 72
order by client_id desc
limit 1;

-- Getting the three lowest amounts in the loan table:
select amount
from loan
order by amount asc
limit 3;

-- Getting the possible values for status ordered alphabetically in ascending order:
select distinct(status)
from loan
order by status asc;

-- Getting the loan_id of the highest payment received:
select loan_id
from loan
order by payments
limit 1;

-- Getting the loan amount of the lowest 5 account_id:
select account_id, amount
from loan
order by account_id asc
limit 5;

-- Getting the account_id with the lowest amount that have a duration of 60:
select account_id
from loan
where duration = 60
order by amount asc
limit 5;

-- Getting the unique values for k-symbols
select distinct(k_symbol)
from `order`;

-- Getting the order_id's of the account_id 34:
select order_id
from `order`
where account_id = 34;

-- Getting which account_ids were responsible for the orders between 29540 and 29560:
select distinct(account_id)
from `order`
where order_id > 29539 and order_id < 29561;

-- Getting what are the individual amounts that were sent to account_to 30067122:
select amount
from `order`
where account_to = 30067122;

-- Getting the trans_id, date, type and amount of the 10 first transactions from account_id 793 in chronological order, from newest to oldest.
select trans_id, `date`, `type`, amount
from trans
where account_id = 793
order by `date` desc
limit 10;

-- Getting how many clients are from each district_id with a value lower than 10:
select district_id, count(client_id) as client_id 	
from `client`
where district_id < 10
group by district_id
order by district_id asc;

-- Getting how many cards exist for each type. Ranking it for the most common value of rank.
select `type`, count(card_id) as Number_of_Cards
from card
group by `type`
order by count(card_id) desc;

-- Getting the top 10 account_ids based on the sum of all of their loan amounts.
select account_id, sum(amount)
from loan
group by account_id
order by sum(amount) desc
limit 10;

-- Getting the number of loans issued for each day, before (excl) 930907, ordered by date in descending order.
select `date`, count(loan_id) as Number_Of_Loans
from loan
where `date` < 930907
group by `date`
order by `date` desc;

-- Getting for each day in December 1997 the count of loans issued for each unique loan duration, ordered by date and duration, both in ascending order:
SELECT `date`, duration, COUNT(loan_id) AS loan_count
FROM loan
WHERE `date` > 971200 AND `date` < 980100
GROUP BY duration, `date`
ORDER BY `date` ASC, duration ASC;

-- Summing the amount of transactions for each type 
select account_id, type, sum(amount) as total_amount
from trans
where account_id = 396
group by account_id, type
order by type asc;

-- Using the previous query, translating the type to english, renaming the column to transaction_typer and rounding the result to an integer:
select 
    account_id,
    case
        when type = 'VYDAJ' then 'Outgoing'
        when type = 'PRIJEM' then 'Incoming'
    end as transaction_type,
    floor(sum(amount)) as total_amount
from trans
where account_id = 396
group by account_id, type
order by transaction_type asc;

-- Modifying the query so, with the previous result in mind, getting the results in only one row:
select 
    round((select sum(amount) from trans where account_id = 396 and type = 'PRIJEM')) as incoming_amount,
    round((select sum(amount) from trans where account_id = 396 and type = 'VYDAJ')) as outgoing_amount,
    round((select sum(case when type = 'PRIJEM' then amount else -amount end) from trans where account_id = 396)) as difference;
    
-- Ranking the top 10 account_id by their difference:
select 
    account_id,
    round(sum(case when type = 'PRIJEM' then amount else 0 end)) -
    round(sum(case when type = 'VYDAJ' then amount else 0 end)) as difference
from trans
group by account_id
order by difference desc
limit 10;