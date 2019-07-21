package com.pasviegas.discounts.test
import org.scalatest.Assertion

package object database {
  import scalikejdbc._

  Class.forName("org.h2.Driver")
  ConnectionPool.singleton("jdbc:h2:mem:hello", "user", "pass")

  implicit val session = AutoSession

  sql"""
       create table users (
       	id varchar(255) primary key,
       	first_name varchar(255) not null,
       	last_name varchar(255) not null,
       	date_of_birth date not null
       );

       INSERT INTO users (id, first_name, last_name, date_of_birth) VALUES ('8PiisPOauwPZzWTT', 'Pedro', 'Viegas', '1988-06-01');

       create table products (
       	id varchar(255) primary key,
       	title varchar(255) not null,
       	description varchar(255) not null,
       	price_in_cents int not null
       );

        INSERT INTO products (id, title, description, price_in_cents) VALUES ('GyhyFM3T3U88mg4d', 'Bottle', 'Good', 890);
     """.execute.apply()

  def withSession(test: DBSession => Assertion): Assertion = {
    test(session)
  }
}
