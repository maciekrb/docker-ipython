**Build**

```
docker-compose build
```


**Run**

```
docker-compose run --service-ports notebook bash
```

```
jupyter notebook --ip 0.0.0.0 --port 8888
```


**Configuration Commands**

```
%load_ext oct2py.ipython
%matplotlib inline
```
