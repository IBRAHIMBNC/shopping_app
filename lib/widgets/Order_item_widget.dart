import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shopping_app/providers/orders.dart';

class OrderItemWid extends StatefulWidget {
  final OrderItem orderProd;
  const OrderItemWid({required this.orderProd});

  @override
  _OrderItemWidState createState() => _OrderItemWidState();
}

class _OrderItemWidState extends State<OrderItemWid> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      height: _isExpanded
          ? min(widget.orderProd.orderItems.length * 30.0 + 110, 200)
          : 90,
      child: Card(
        elevation: 4,
        child: Container(
          padding: EdgeInsets.all(5),
          child: Column(
            children: [
              ListTile(
                title: Text(
                  '\$${widget.orderProd.total.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                subtitle: Text(DateFormat('dd/MM/yyyy hh:mm')
                    .format(widget.orderProd.date)),
                trailing: IconButton(
                  onPressed: () {
                    setState(() {
                      _isExpanded = !_isExpanded;
                    });
                  },
                  icon:
                      Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
                ),
              ),
              AnimatedContainer(
                duration: Duration(
                  milliseconds: 300,
                ),
                padding: EdgeInsets.all(5),
                height: _isExpanded
                    ? min(widget.orderProd.orderItems.length * 30.0 + 20, 180)
                    : 0,
                child: ListView(
                  children: widget.orderProd.orderItems.map((item) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${item.title}',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Text('\$${item.price} x ${item.quantity}',
                            style: TextStyle(fontSize: 18))
                      ],
                    );
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
