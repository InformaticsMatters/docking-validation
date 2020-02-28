FROM informaticsmatters/deep-app-ubuntu-1604:1.0

COPY xchem_deep_score.py /root/train/fragalysis_test_files/
RUN mv /root/train /train &&\
 chmod 755 /train &&\
 chmod 775 -R /train/fragalysis_test_files &&\
 chmod 777 /train/fragalysis_test_files &&\
 chown -R 0.0 /train

WORKDIR /train/fragalysis_test_files