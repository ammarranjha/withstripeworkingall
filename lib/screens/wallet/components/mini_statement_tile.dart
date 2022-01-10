import 'package:flutter/material.dart';
import 'package:pool_your_car/models/MiniStatementModel.dart';
import 'package:pool_your_car/size_config.dart';
    
class MiniStatementTile extends StatelessWidget {

  const MiniStatementTile({ Key key, this.miniStatementModel, this.userId }) : super(key: key);

  final MiniStatementModel miniStatementModel;
  final String userId;
  
  @override
  Widget build(BuildContext context) {
    final isReciever = miniStatementModel.toId == userId;

    return Container(
      height: 350,
      padding: const EdgeInsets.only(left: 15.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: isReciever ? [
          const Divider(),
          const Padding(
            padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 7.0),
            child: SizedBox(
              child: Text(
                "Credit",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: 20),

          SizedBox(
            child: Row(
              children: [
                const Text(
                  'From :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Expanded(child: SizedBox()),

                Text(
                  miniStatementModel.fromName??'',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          if (miniStatementModel.fromName != 'Admin')
            SizedBox(
              child: Row(
                children: [
                  const Text(
                    'ID :',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  const Expanded(child: SizedBox()),

                  Text(
                    miniStatementModel.from??'',
                    style: const TextStyle(
                      fontSize: 16,
                    ),
                  )
                ],
              ),
            ),

          const Divider(),

          SizedBox(height: 20),

          SizedBox(
            child: Row(
              children: [
                const Text(
                  'Amount :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Expanded(child: SizedBox()),

                Text(
                  '${miniStatementModel.amount??""}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          SizedBox(
            child: Row(
              children: [
                const Text(
                  'Date :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Expanded(child: SizedBox()),

                Text(
                  miniStatementModel.date??"",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),

          const Divider(),
        ]:
        [
          const Divider(),

          const Padding(
            padding: EdgeInsets.only(left: 25.0, top: 10.0, bottom: 7.0),
            child: SizedBox(
              child: Text(
                "Debit",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

          SizedBox(height: SizeConfig.screenHeight * 0.05),
          
          SizedBox(
            child: Row(
              children: [
                const Text(
                  'To :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Expanded(child: SizedBox()),

                Text(
                  miniStatementModel.toName??'',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),

         SizedBox(height: 20),

          SizedBox(
            child: Row(
              children: [
                const Text(
                  'ID :',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Expanded(child: SizedBox()),

                Text(
                  miniStatementModel.to??'',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),

          const Divider(),

          SizedBox(height: 20),

          SizedBox(
            child: Row(
              children: [
                const Text(
                  'Amount :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Expanded(child: SizedBox()),

                Text(
                  '${miniStatementModel.amount??""}',
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),

          SizedBox(height: 20),

          SizedBox(
            child: Row(
              children: [
                const Text(
                  'Date :',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                ),

                const Expanded(child: SizedBox()),

                Text(
                  miniStatementModel.date??"",
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                )
              ],
            ),
          ),

          const Divider(),
        ],
      ),
    );
  }
}