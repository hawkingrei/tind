# tind

TiDB in Docker

## Usage

```
> $ sudo docker run -d -p 4001:4000 hawkingrei/tind:v4.0.14                                                                                                                           [±main ●]
ca060d6b234aed8c5d2ad0705154cd8bbc92a8dfaa6d11e7a0faaa68509eb034
> $ mycli -P 4001  -h 127.0.0.1  -u root                                                                                                                                              [±main ●]
MySQL 5.7.25
mycli 1.24.1
Home: http://mycli.net
Bug tracker: https://github.com/dbcli/mycli/issues
Thanks to the contributor - Michał Górny
MySQL root@127.0.0.1:(none)> select version();
+---------------------+
| version()           |
+---------------------+
| 5.7.25-TiDB-v4.0.14 |
+---------------------+
1 row in set
Time: 0.008s
```