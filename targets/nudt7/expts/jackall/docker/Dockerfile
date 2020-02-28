FROM informaticsmatters/deep-app-ubuntu-1604:latest

COPY xchem_deep_score.py /root/train/fragalysis_test_files
RUN mv /root/train /
RUN chmod 755 /train
RUN chmod 775 -R /train/fragalysis_test_files
RUN chmod 777 /train/fragalysis_test_files
RUN chown -R 0.0 /train