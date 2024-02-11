
--> создаем таблицу customers
create table customers (
customer_id INT
,first_name TEXT
,last_name TEXT
,gender VARCHAR(10)
,DOB VARCHAR(10)
,job_title text
,job_industry_category TEXT
,wealth_segment TEXT
,deceased_indicator VARCHAR(4)
,owns_car BOOL
,address TEXT
,postcode INT
,state TEXT
,country TEXT
,property_valuation INT)


--> создаем таблицу transactions
create table transaction (
transaction_id INT
,product_id INT
,customer_id INT
,transaction_date VARCHAR(10)
,online_order BOOL
,order_status VARCHAR(16)
,brand TEXT
,product_line TEXT
,product_class VARCHAR(16)
,product_size VARCHAR(16)
,list_price DECIMAL
,standard_cost DECIMAL
)

--> меняем тип поля
alter table customers 
alter column owns_car type varchar(10)

--> переводим колонку owns_car в BOOL в я вном виде
alter table customers 
alter column owns_car type boolean using
case
	when owns_car = 'Yes' then true
	when owns_car = 'No' then false
end

--> задание 1: Вывести все уникальные бренды у которых стандартная стоимость выше 1500 долларов

select distinct(brand)
from "transaction" t 
where standard_cost > 1500


--> задание 2: Вывести все подтвержденные транзакции за период '2017-04-01' по '2017-04-09' включительно.
select *
from transaction t
where to_date(transaction_date, 'DD.MM.YYYY') between '2017-04-01' and '2017-04-09'


--> задание 3: Вывести все профессии у клиентов из сферы IT или Financial Services, которые начинаются с фразы 'Senior'.
select distinct(job_title)
from customers c 
where (job_industry_category = 'IT' or job_industry_category = 'Financial Services') and job_title like 'Senior%'


--> Задание 4: Вывести все бренды, которые закупают клиенты, работающие в сфере Financial Services
select distinct(brand)
from "transaction" t 
where customer_id in (
	select customer_id 
	from customers c 
	where job_industry_category = 'Financial Services'
	)


--> Задание 5: Вывести 10 клиентов, которые оформили онлайн-заказ продукции из брендов 'Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles'.
	select customer_id, first_name, last_name
	from customers c 
	where customer_id in (
		select customer_id 
		from "transaction" t 
		where brand in ('Giant Bicycles', 'Norco Bicycles', 'Trek Bicycles')
	)
	limit(10)
	
--> Задание 6: Вывести всех клиентов, у которых нет транзакций.
	select c.customer_id, c.first_name, c.last_name
	from customers c 
	left join transaction t 
	on c.customer_id = t.customer_id
	where t.customer_id is null
	
--> Задание 7: Вывести всех клиентов из IT, у которых транзакции с максимальной стандартной стоимостью.
	select c.*
	from customers c 
	inner join transaction t
	on c.customer_id = t.customer_id 
	where c.job_industry_category = 'IT'
		and t.standard_cost = (
					select max(t2.standard_cost) 
					from transaction t2
					)

--> Задание 8: Вывести всех клиентов из сферы IT и Health, у которых есть подтвержденные транзакции за период '2017-07-07' по '2017-07-17'.
	select c.*, t.transaction_date 
	from customers c 
	inner join transaction t
	on c.customer_id = t.customer_id 
	where c.job_industry_category = 'IT'
		and to_date(t.transaction_date, 'DD.MM.YYY') in (
									select to_date(t2.transaction_date, 'DD.MM.YYYY') 
									from transaction t2 
									where to_date(t2.transaction_date, 'DD.MM.YYYY') between '2017-07-07' and '2017-07-17'
									)