/*Question 1*/
select b.calmonth,d.addrcatcodeid,sum(extcost),sum(quantity)
from inventory_fact a
inner join date_dim b
on a.datekey =b.datekey
inner join cust_vendor_dim c
on a.custvendorkey=c.custvendorkey
inner join addr_cat_code1 d
on c.addrcatcode1=d.addrcatcodekey
where transtypekey=5 and calyear=2011
group by cube(b.calmonth,d.addrcatcodeid)

/*Question 2*/
select b.calquarter,c.zip,c.name,sum(extcost),count(*) AS InventoryCount
from inventory_fact a
inner join date_dim b
on a.datekey =b.datekey
inner join cust_vendor_dim c
on a.custvendorkey=c.custvendorkey
where calyear in(2011,2012) and  transtypekey=5
group by grouping sets((b.calquarter,c.zip,c.name),(b.calquarter,c.zip),(c.zip,c.name)
,(b.calquarter,c.name),(b.calquarter),(c.zip),(c.name),());

/*Question 3*/
select  B.bpname,C.companyname, 
sum(d.quantity) as tot_qunty, 
sum(d.extcost) as tot_extcost
from branch_plant_dim B 
inner join company_dim C  
on B.companykey = c.companykey
inner join inventory_fact  d 
on B.branchplantkey= d.branchplantkey                   
where d.transtypekey = 2
group by rollup(C.companyname,B.bpname);

/*question 4*/
select t.transdescription,
       c.companyname,
       b.bpname, 
      count(*) as transac_count, 
      sum(I.EXTCOST) as extcost
from branch_plant_dim B 
inner join company_dim C  
on B.companykey = C.companykey
inner join inventory_fact  I  
on B.branchplantkey= I.branchplantkey 
inner join trans_type_dim T 
on i.transtypekey=i.transtypekey
group by grouping sets((T.transdescription,C.companyname,B.bpname),T.transdescription,C.companyname,B.bpname,());

/*Question 5*/

select d.name,c.calyear,c.calquarter,sum(a.extcost),count(*) as transac_count
from inventory_fact a
inner join trans_type_dim b
on a.transtypekey =b.transtypekey
inner join date_dim c
on a.datekey =c.datekey
inner join cust_vendor_dim d
on a.custvendorkey =d.custvendorkey
where a.transtypekey=5 and c.calyear in (2011,2012)
group by d.name,rollup(c.calyear,c.calquarter);

/*Question 6 */
select b.calmonth,d.addrcatcodeid,sum(extcost),sum(quantity)
from inventory_fact a
inner join date_dim b
on a.datekey =b.datekey
inner join cust_vendor_dim c
on a.custvendorkey=c.custvendorkey
inner join addr_cat_code1 d
on c.addrcatcode1=d.addrcatcodekey
where transtypekey=5 and calyear=2011
GROUP BY (b.calmonth,d.addrcatcodeid)
UNION
select b.calmonth,NULL,sum(extcost),sum(quantity)
from inventory_fact a
inner join date_dim b
on a.datekey =b.datekey
inner join cust_vendor_dim c
on a.custvendorkey=c.custvendorkey
inner join addr_cat_code1 d
on c.addrcatcode1=d.addrcatcodekey
where transtypekey=5 and calyear=2011
GROUP BY(b.calmonth)
UNION 
select NULL,d.addrcatcodeid,sum(extcost),sum(quantity)
from inventory_fact a
inner join date_dim b
on a.datekey =b.datekey
inner join cust_vendor_dim c
on a.custvendorkey=c.custvendorkey
inner join addr_cat_code1 d
on c.addrcatcode1=d.addrcatcodekey
where transtypekey=5 and calyear=2011
group by(d.addrcatcodeid)
UNION 
select NULL,NULL,sum(extcost),sum(quantity)
from inventory_fact a
inner join date_dim b
on a.datekey =b.datekey
inner join cust_vendor_dim c
on a.custvendorkey=c.custvendorkey
inner join addr_cat_code1 d
on c.addrcatcode1=d.addrcatcodekey
where transtypekey=5 and calyear=2011

/*question 7*/
select  B.bpname,C.companyname, 
sum(d.quantity) as tot_qunty, 
sum(d.extcost) as tot_extcost
from branch_plant_dim B 
inner join company_dim C  
on B.companykey = c.companykey
inner join inventory_fact  d 
on B.branchplantkey= d.branchplantkey                   
where d.transtypekey = 2
group by (C.companyname,B.bpname)
UNION
select  NULL,C.companyname, 
sum(d.quantity) as tot_qunty, 
sum(d.extcost) as tot_extcost
from branch_plant_dim B 
inner join company_dim C  
on B.companykey = c.companykey
inner join inventory_fact  d 
on B.branchplantkey= d.branchplantkey                   
where d.transtypekey = 2
group by (C.companyname)
UNION
select  NULL,NULL, 
sum(d.quantity) as tot_qunty, 
sum(d.extcost) as tot_extcost
from branch_plant_dim B 
inner join company_dim C  
on B.companykey = c.companykey
inner join inventory_fact  d 
on B.branchplantkey= d.branchplantkey                   
where d.transtypekey = 2;


/*Question 8*/
select D.CALYEAR,D.CALQUARTER,C.NAME, 
count(*) as num_transactions,
sum(I.EXTCOST) as tot_extcost 
from date_dim D 
inner join inventory_fact  I
on D.DATEKEY = I.DATEKEY
inner join cust_vendor_dim  C  
on C.CUSTVENDORKEY = I.CUSTVENDORKEY
where (D.CALYEAR = 2011 or  D.CALYEAR = 2012) and I.TRANSTYPEKEY = 5 
group by  ROLLUP((D.CALYEAR,D.CALQUARTER)),cube(C.NAME);


/*Question 9*/
select b.calmonth,d.addrcatcodeid,sum(extcost),sum(quantity),
GROUPING_ID(b.calmonth, d.addrcatcodeid) AS Grouping_Level
from inventory_fact a
inner join date_dim b
on a.datekey =b.datekey
inner join cust_vendor_dim c
on a.custvendorkey=c.custvendorkey
inner join addr_cat_code1 d
on c.addrcatcode1=d.addrcatcodekey
where transtypekey=5 and calyear=2011
group by cube(b.calmonth,d.addrcatcodeid)
order by Grouping_Level

/*Question 10*/
select b.calyear,b.calquarter,c.name,sum(a.extcost),
Count(*) as count_inventory
from inventory_fact a
inner join date_dim b
on a.datekey =b.datekey
inner join cust_vendor_dim c
on a.custvendorkey=c.custvendorkey
where a.transtypekey=5 and calyear in (2011,2012)
group by grouping sets(c.name, rollup(b.calyear,b.calquarter));


select b.calyear,b.calquarter,c.name,sum(a.extcost),
Count(*) as count_inventory
from inventory_fact a
inner join date_dim b
on a.datekey =b.datekey
inner join cust_vendor_dim c
on a.custvendorkey=c.custvendorkey
where a.transtypekey=5 and calyear in (2011,2012)
group by cube(c.name,(b.calyear,b.calquarter));


 
 