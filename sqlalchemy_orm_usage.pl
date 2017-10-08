#!/usr/bin/perl
foreach (<DATA>)
{
	print $_;
}

__DATA__
sqlalchemy
qa_db_orm/
#--------------------------------------------------------------------------
#0
sqlacodegen  mysql://root:password@localhost/a0619113740             --tables  ss_products              --outfile  products.py
sqlacodegen  mysql://root:password@localhost/a0619113740             --tables  ss_product_categories    -outfile   product_categories.py 

#--------------------------------------------------------------------------
#2. 
#代码中 import  answer  


#--------------------------------------------------------------------------
#3.
#filter 用法: 
for each in  s.query(products.SsProduct).filter("s_locale = 'en'"):
    print "%s"%(each.name);

#字符串匹配。 
for each in  s.query(models_question.Question).filter(models_question.Question.content.contains("爱")):
    print "%s|%s"%(each.q_id,each.content);

#update 
query.filter(User.id == 1).update({User.name: 'c'})

#append
mary.addresses.append(Address('mary2@gmail.com'))
session.flush()

#删除, delete 
# s.query.filter(User.id == 1).delete() #老的写法.
s.query(product_categories.SsProductCategory).filter( product_categories.SsProductCategory.name == "test_name").delete()


#session.flush() # 写数据库，但并不提交
# session.commit()

billingResources=session.query(BillingResource).filter(BillingResource.parent_id==self.billingResource.resource_id).all()

#filte_by 的用法.
result = (session.query(models.PortBindingLevel).filter_by(port_id=port_id, host=host).order_by(models.PortBindingLevel.level).all())
