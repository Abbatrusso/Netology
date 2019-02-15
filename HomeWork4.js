db.tags.count()
print("tags count: ", 'расчёт количества тегов');

db.tags.count({name: "woman"})
print("woman tags count: ", 'расчёт количества тегов woman');

printjson(
           db.tags.aggregate([
                {$group: {
                                 _id: "$name", 
                                 tag_count: { $sum: 1 }
                                 }
                },
          {$sort: {tag_count: -1} }, 
          {$limit: 3}
           ])['_batch']
);
